// Status code: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#information_responses

const MessageDialogService = {
  msgTypes: {
    SUCCESS: 'success',
    WARNING: 'warning',
    ERROR: 'error',
    INFO: 'info'
  },
  showDialog: (data) => {
    let msg = '';
    let msgType = MessageDialogService.msgTypes.SUCCESS;
    let showClose = true
    let response = ''

    if(data){
      msg = data['message']
      msgType = data['type']
      showClose = data['showClose']
      response = data['response']
    }
    if(response){
      msg = response.data.msg
      if(response.status > 99 && response.status < 200){
        msgType = MessageDialogService.msgTypes.INFO;
      }
      if (response.status > 199 && response.status < 300) {
        msgType = MessageDialogService.msgTypes.SUCCESS;
      }
      if(response.status > 399 && response.status < 500){
        msgType = MessageDialogService.msgTypes.ERROR;
      }
    }

    Vue.prototype.$message({
      message: msg,
      type: msgType,
      showClose: showClose,
    });
  }
};

export default MessageDialogService;