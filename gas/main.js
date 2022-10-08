/** スケジュール一覧を保存するシート名。 */
const schedulesSheetName = 'schedules'

/** ヘッダ行を除く最初の有効なデータセル */
const firstCell = {
  row: 2,
  column: 1,
}

/**
 * GET API
 */
function doGet(e) {
  const sheet =
    SpreadsheetApp.getActiveSpreadsheet().getSheetByName(schedulesSheetName)
  const range = sheet.getRange(
    firstCell.row,
    firstCell.column,
    sheet.getLastRow() - (firstCell.row - 1), // ヘッダ行を除くため
    sheet.getLastColumn()
  )
  const body = range.getValues().map((row) => {
    return {
      scheduleId: row[0],
      title: row[1],
      createdAt: row[2],
      dueDateTime: row[3],
      isNotified: row[4],
    }
  })
  const response = ContentService.createTextOutput(JSON.stringify(body))
  response.setMimeType(ContentService.MimeType.JSON)
  return response
}

/**
 * POST API
 */
function doPost(e) {
  // NOTE: type の判定は未対応。
  const title = e.parameter.title
  const dueDateTime = new Date(e.parameter.dueDateTime)

  const record = {
    // schedule を識別するのにフィールドに UUID をもたせるのはちょっと冗長か...？
    // 行番号でも十分か...？
    scheduleId: getUuid(),
    title,
    dueDateTime,
    createdAt: new Date(),
    isNotified: false,
  }

  const sheet =
    SpreadsheetApp.getActiveSpreadsheet().getSheetByName(schedulesSheetName)
  sheet.appendRow(Object.values(record))
  const response = ContentService.createTextOutput(JSON.stringify(record))
  response.setMimeType(ContentService.MimeType.JSON)
  return response
}

/** UUID を生成する。 */
function getUuid() {
  return Utilities.getUuid()
}
