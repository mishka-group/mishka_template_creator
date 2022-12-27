import 'phoenix_html';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import Sortable from 'sortablejs';

// Start Hooks object
let Hooks = {};

// Start hooks Functions, this place we put some hooks we defined in elixir side and communicate with backend
Hooks.SectionDrag = {
  mounted() {
    // This is a simple way based on JS Listener
    this.el.addEventListener('click', (e) => {
      console.log(e);
    });

    // This is a way for sending data to client from backend
    // example `{:noreply, push_event(socket, "points", %{points: new_points})}` from `<div id="chart" phx-hook="Chart">`
    // example get from server in client side: `this.handleEvent("points", ({points}) => MyChartLib.addPoints(points))`
    this.handleEvent('createSection', ({ sectionType }) => {
      console.log(sectionType);

      // send back to the server
      this.pushEvent('change-section', {});
    });
  },
};

// Configure and introduce functions to Phoenix LiveView
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' });
window.addEventListener('phx:page-loading-start', (info) =>
  topbar.delayedShow(200)
);
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
