async function init(config) {
  console.log('init called')
  await liff
    .init({
      liffId: config['liffId'],
      withLoginOnEternalBrowser: true,
    })
    .then(() => {
      config['successCallback']()
    })
    .catch((err) => {
      config['errorCallback'](err)
    })
}

function getLiffId() {
  return liff.id
}

/**
 * @param {boolean} ignoreError エラーを無視して、空文字を返す。
 * LIFF アプリとしてではなく、単なる Flutter Web アプリとしてデバッグするような
 * 用途を想定し、ignoreError = true を指定すると、エラーを握りつぶして、空文字を返す。
 *
 * @return {string} LIFF アプリとして起動している際に得られる userId を返す。
 */
async function getUserId(ignoreError = false) {
  if (ignoreError) {
    try {
      console.log('getUserId called')
      const profile = await liff.getProfile()
      return profile['userId']
    } catch (e) {
      console.error('ユーザー ID が取得できませんでした。')
      return ''
    }
  } else {
    console.log('getUserId called')
    const profile = await liff.getProfile()
    return profile['userId']
  }
}

async function getGroupId() {
  console.log('getGroupId called')
  const context = await liff.getContext()
  return context['groupId']
}

async function getAccessToken() {
  console.log('getAccessToken called')
  return await liff.getAccessToken()
}
