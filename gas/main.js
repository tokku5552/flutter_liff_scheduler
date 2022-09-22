/** スケジュール一覧を保存するシート名。 */
const schedulesSheetName = 'schedules'

/**
 * POST API
 */
function doPost(e) {
  // NOTE: type の判定は未対応。
  const data = JSON.parse(e.postData.contents)
  const title = data.title
  const dueDateTime = new Date(Date.parse(data.dueDateTime))
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
