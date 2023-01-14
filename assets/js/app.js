import 'phoenix_html';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import { customEventCreator } from '../vendor/mishka_template_creator/utilities';
// import {
//   LayoutGroup,
//   ContentGroup,
// } from '../vendor/mishka_template_creator/layout';
import Sortable from 'sortablejs';

const layoutBlock = document.getElementById('layoutBlock');
const dragLocation = document.getElementById('dragLocation');
const sortableSpeed = 150;

Sortable.create(layoutBlock, {
  group: {
    name: 'LayoutGroup',
    pull: 'clone',
    put: false,
  },
  animation: sortableSpeed,
  sort: false,
});

Sortable.create(dragLocation, {
  group: {
    name: 'ContentGroup',
    put: ['LayoutGroup'],
  },
  animation: sortableSpeed,
  swapThreshold: 0.65,
  onAdd: function (/**Event*/ evt) {
    customEventCreator('serverNotification', evt.item, {
      index: evt.newIndex,
      type: evt.item.dataset.type,
      parent: evt.to.dataset.type,
      parent_id: evt.to.id,
    });
    evt.item.remove();
  },
});
// Start Hooks object
let Hooks = {};

// LayoutGroup;
// ContentGroup;

// Start hooks Functions, this place we put some hooks we defined in elixir side and communicate with backend
Hooks.dragAndDropLocation = {
  mounted() {
    // This is a simple way based on JS Listener
    const liveView = this;
    this.el.addEventListener('serverNotification', (e) => {
      e.preventDefault();
      // send back to the server
      this.pushEvent('dropped_element', {
        index: e.detail.index,
        type: e.detail.type,
        parent: e.detail.parent,
        parent_id: e.detail.parent_id,
      });
    });

    // This is a way for sending data to client from backend
    // example `{:noreply, push_event(socket, "points", %{points: new_points})}` from `<div id="chart" phx-hook="Chart">`
    // example get from server in client side: `this.handleEvent("points", ({points}) => MyChartLib.addPoints(points))`
    this.handleEvent('delete', ({ id }) => {
      const element = document.getElementById(id);
      element.remove();
      if (dragLocation.children.length === 1) {
        previewHelper.classList.remove('hidden');
      }
    });

    this.handleEvent('create_draggable', ({ id, layout }) => {
      const element = document.getElementById(id);
      Sortable.create(element, {
        group: { name: `${layout}-${id}`, put: ['LayoutGroup'] },
        animation: 150,
        swapThreshold: 0.65,
        onAdd: function (/**Event*/ evt) {
          liveView.pushEvent('dropped_element', {
            index: evt.newIndex,
            type: evt.item.dataset.type,
            parent: evt.to.dataset.type,
            parent_id: evt.to.id,
          });
          evt.item.remove();
        },
      });
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
