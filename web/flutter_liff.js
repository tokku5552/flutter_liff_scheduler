async function init(liff_id, successCallback, errorCallback){
    console.log("init called")
    console.log(`liff ID: ${liff_id}`)
    await liff.init({
        liffId: liff_id,
        withLoginOnEternalBrowser: true,
    })
    .then(() => {
        successCallback()
     })
     .catch((err) => {
         errorCallback(err)
     });
}

function getLiffID(){
    return liff.id
}

async function getUserID(){
    console.log("getUserID called")
    console.log(`liff ID is ${liff.id}`)
   const profile = await liff.getProfile()
   console.log(`profile: ${profile}`)
   return profile["userId"]
}

async function getAccessToken(){
    console.log("getAccessToken called")
    console.log(`liff ID is ${liff.id}`)
    return await liff.getAccessToken()
}