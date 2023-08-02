const MessageDialogService = {
  msgTypes: {
    SUCCESS: 'success',
    WARNING: 'warning',
    ERROR: 'error',
    INFO: 'info'
  },
  showDialog: (data) => {
    let msg = '';
    let msg_type = MessageDialogService.msgTypes.SUCCESS;
    let showClose = true

    if(data){
      msg = data['message']
      msgType = data['type']
      showClose = data['showClose']
    }

    Vue.prototype.$message({
      message: msg,
      type: msg_type,
      showClose: showClose,
    });
  }
};

export default MessageDialogService;