const WalkyTalky = {
  autoDismissDelay() {
    return Number(this.el.dataset.autoDismissDelay) || 0;
  },
  dismissHandler() {
    return this.el.dataset.dismissHandler;
  },
  mounted() {
    if (this.autoDismissDelay() > 0) {
      setTimeout(() => {
        liveSocket.execJS(this.el, this.dismissHandler());
      }, this.autoDismissDelay());
    }
  },
};

export { WalkyTalky };
