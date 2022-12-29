import 'phoenix_html';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import Sortable from 'sortablejs';

// Start Hooks object
let Hooks = {};

//
const getBlocks = document.getElementById('layout-block');
const putBlock = document.getElementById('dragLocation');
const previewHelper = document.getElementById('previewHelper');
const sortableSpeed = 150;

var sortable1 = Sortable.create(getBlocks, {
  group: {
    name: 'group1',
    pull: 'clone',
    put: false,
  },
  animation: sortableSpeed,
  sort: false,
  onStart: function (evt) {
    previewHelper.classList.add('hidden');
  },
  onEnd: function (evt) {
    if (putBlock.children.length === 1) {
      previewHelper.classList.remove('hidden');
    } else {
      // It is a custom listener to let Phoenix LiveView hook, something happened that it should be listen.
      const eventAwesome = new CustomEvent('awesome', {
        bubbles: true,
        detail: { text: 'test params' },
      });
      // This is a sender and dispatcher for event
      evt.item.dispatchEvent(eventAwesome);
    }
  },
});

var sortable2 = Sortable.create(putBlock, {
  group: {
    name: 'group2',
    put: ['group1'],
  },
  animation: sortableSpeed,
  swapThreshold: 0.65,
  onAdd: function (/**Event*/ evt) {
    const sectionID = evt.item.id;
    evt.item.removeAttribute('data-id');
    evt.item.removeAttribute('phx-click');
    evt.item.setAttribute('id', sectionID + '-clone');
    const blockCodeID = document.querySelector(`[data-id="${sectionID}"]`);
    blockCodeID.setAttribute('id', sectionID);
  },
});

// Start hooks Functions, this place we put some hooks we defined in elixir side and communicate with backend
Hooks.dragAndDropLocation = {
  mounted() {
    // This is a simple way based on JS Listener
    this.el.addEventListener('awesome', (e) => {
      e.preventDefault();
      console.log(e.detail.text);

      // send back to the server
      this.pushEvent('change-section', {});
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
