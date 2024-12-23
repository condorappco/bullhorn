const Bullhorn = {
  autoDismissDelay() {
    return Number(this.el.dataset.autoDismissDelay) || 0;
  },
  dismissHandler() {
    return this.el.dataset.dismissHandler;
  },
  progressBar() {
    return this.el.querySelector(".progress-bar");
  },
  mounted() {
    if (this.autoDismissDelay() > 0) {
      this.progressBar().style.transitionDuration = `${this.autoDismissDelay()}ms`;
      this.progressBar().style.width = "100%";

      setTimeout(() => {
        liveSocket.execJS(this.el, this.dismissHandler());
      }, this.autoDismissDelay());
    }
  },
};

export { Bullhorn };
