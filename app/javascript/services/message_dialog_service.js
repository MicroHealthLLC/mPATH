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
    // if (response.status === 200) {
    //   msgType = MessageDialogService.msgTypes.SUCCESS;
    // }
    // if (response.status !== 200) {
    //   this.errorTrue = true
    // }
    Vue.prototype.$message({
      message: msg,
      type: msgType,
      showClose: showClose,
    });
  }
};

export default MessageDialogService;