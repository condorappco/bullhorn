const WalkyTalky = {
  autoCloseDelay() {
    return Number(this.el.dataset.autoCloseDelay) || 0;
  },
  dismissHandler() {
    return this.el.dataset.dismissHandler;
  },
  mounted() {
    if (this.autoCloseDelay() > 0) {
      setTimeout(() => {
        liveSocket.execJS(this.el, this.dismissHandler());
      }, this.autoCloseDelay());
    }
  },
};

export { WalkyTalky };
