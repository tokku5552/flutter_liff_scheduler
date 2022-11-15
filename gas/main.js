/** スケジュール一覧を保存するシート名。 */
const SCHEDULES_SHEET_NAME = 'schedules'

/** スプレッドシートのスキーマ。 */
const SCHEMA = {
  rowNumber: {
    columnName: 'rowNumber',
    columnIndex: 0,
  },
  userId: {
    columnName: 'userId',
    columnIndex: 1,
  },
  title: {
    columnName: 'title',
    columnIndex: 2,
  },
  dueDateTime: {
    columnName: 'dueDateTime',
    columnIndex: 3,
  },
  isNotified: {
    columnName: 'isNotified',
    columnIndex: 4,
  },
}

/** ヘッダ行を除く最初の有効なデータセル。 */
const firstCell = { row: 2, column: 1 }

/** スケジュール一覧が記録されているシート。 */
function getSchedulesSheet() {
  return SpreadsheetApp.getActiveSpreadsheet().getSheetByName(
    SCHEDULES_SHEET_NAME
  )
}

/**
 * 毎時実行して、次の 1 時間の間のスケジュールを LINE Messaging API でお知らせする。
 * お知らせが済んだものは isNotified = true にする。
 *
 * 例：
 * この関数が、2022-11-01 09:20:00 に発火した場合、
 * dueDateTime が 2022-11-01 10:00:00 〜 2022-11-01 10:59:59 の間である
 * スケジュールを含むメッセージが送信される。
 * */
function notifySchedules() {
  const notificationTargetSchedules = fetchNotificationTargetSchedules()
  if (notificationTargetSchedules.length === 0) {
    console.log('近づいているスケジュールはありません。')
    return
  }

  const rowNumbers = []
  const messagesByUserId = {}
  for (const row of notificationTargetSchedules) {
    const userId = row[SCHEMA.userId.columnIndex]
    const message = `${row[SCHEMA.title.columnIndex]} (${row[
      SCHEMA.dueDateTime.columnIndex
    ].toLocaleString('ja-JP')})`
    if (userId in messagesByUserId) {
      messagesByUserId[userId].push(message)
    } else {
      messagesByUserId[userId] = [message]
    }
    rowNumbers.push(row[SCHEMA.rowNumber.columnIndex])
  }

  for (const userId in messagesByUserId) {
    console.log(`userId: ${userId}, messages: ${messagesByUserId[userId]}`)
    pushMessageToUser(userId, messagesByUserId[userId])
  }

  setIsNotified(rowNumbers)
}

/** スプレッドシートからスケジュールを全件取得して、dueDateTime の降順にして返す。 */
function fetchAllSchedulesFromSpreadSheet() {
  sheet = getSchedulesSheet()
  const range = sheet.getRange(
    firstCell.row,
    firstCell.column,
    sheet.getLastRow() - (firstCell.row - 1), // ヘッダ行を除くため
    sheet.getLastColumn()
  )
  return range
    .getValues()
    .sort((a, b) =>
      a[SCHEMA.dueDateTime.columnIndex] > b[SCHEMA.dueDateTime.columnIndex]
        ? -1
        : 1
    )
}

/**
 * スケジュール一覧から指定したユーザー ID のものだけをフィルタして返す。
 * @param {string} userId
 * @return {Schedule[]} 指定したユーザー ID のスケジュール一覧
 */
function fetchSchedulesByUserId(userId) {
  const schedules = fetchAllSchedulesFromSpreadSheet()
  return schedules.filter((row) => row[SCHEMA.userId.columnIndex] === userId)
}

/**
 * スケジュール一覧から通知のターゲットとなるものだけをフィルタして返す。
 * @param {Date} minDueDateTime スケジュールの対象を絞り込む dueDateTime の下限値。
 * @param {Date} maxDueDateTime スケジュールの対象を絞り込む dueDateTime の下限値。
 * @return {Schedule[]} 通知の対象となるスケジュール一覧。
 */
function fetchNotificationTargetSchedules() {
  const now = new Date()
  const schedules = fetchAllSchedulesFromSpreadSheet()
  const minDueDateTime = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    now.getHours() + 1
  )
  const maxDueDateTime = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    now.getHours() + 2
  )
  return schedules.filter(
    (row) =>
      row[SCHEMA.dueDateTime.columnIndex] >= minDueDateTime &&
      row[SCHEMA.dueDateTime.columnIndex] < maxDueDateTime &&
      !row[SCHEMA.isNotified.columnIndex]
  )
}

/**
 * 指定した ID のユーザーに、LINE の Messaging API でメッセージを送信する。
 * @param {string} userId ユーザー ID
 * @param {string[]} messageTexts 送信するメッセージ本文一覧
 */
function pushMessageToUser(userId, messageTexts) {
  UrlFetchApp.fetch('https://api.line.me/v2/bot/message/push', {
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      Authorization: `Bearer ${PropertiesService.getScriptProperties().getProperty(
        'CHANNEL_ACCESS_TOKEN'
      )}`,
    },
    method: 'post',
    payload: JSON.stringify({
      to: userId,
      messages: [
        { type: 'text', text: '近づいているスケジュールのお知らせ' },
        ...messageTexts.map((text) => {
          return { type: 'text', text }
        }),
      ],
    }),
  })
}

/**
 * 指定した行番号の isNotified フラグを true に更新する。
 * @param {number[]} rowNumbers
 */
function setIsNotified(rowNumbers) {
  for (const rowNumber of rowNumbers) {
    sheet = getSchedulesSheet()
    sheet.getRange(rowNumber, SCHEMA.isNotified.columnIndex + 1).setValue(true)
  }
}

/**
 * GET API。
 * スケジュール一覧を取得する。
 */
function doGet(e) {
  const userId = e.parameter.userId
  if (userId === undefined) {
    console.error('userId が指定されていません。')
    throw 'userId を指定してください。'
  }
  const schedules = fetchSchedulesByUserId(userId)
  const body = schedules.map((row) => {
    return {
      userId: row[SCHEMA.userId.columnIndex],
      title: row[SCHEMA.title.columnIndex],
      dueDateTime: row[SCHEMA.dueDateTime.columnIndex].getTime(),
      isNotified: row[SCHEMA.isNotified.columnIndex],
    }
  })
  const response = ContentService.createTextOutput(JSON.stringify(body))
  response.setMimeType(ContentService.MimeType.JSON)
  return response
}

/**
 * POST API。
 * スケジュールを登録する。
 */
function doPost(e) {
  const rowNumber = '= ROW()'
  const userId = e.parameter.userId
  const title = e.parameter.title
  const dueDateTime = new Date(e.parameter.dueDateTime)
  const isNotified = false
  const values = { rowNumber, userId, title, dueDateTime, isNotified }

  sheet = getSchedulesSheet()
  sheet.appendRow(Object.values(values))
  const response = ContentService.createTextOutput(JSON.stringify(values))
  response.setMimeType(ContentService.MimeType.JSON)
  return response
}
