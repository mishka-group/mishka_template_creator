import 'phoenix_html';
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import { customEventCreator } from '../vendor/mishka_template_creator/utilities';
import Sortable from 'sortablejs';

let stateLessConfig = 'none';
const dragLocation = document.getElementById('dragLocation');
const previewHelper = document.getElementById('previewHelper');

function defineBlocksDragAndDrop() {
  const layoutBlock = document.getElementById('layout-block');
  const elementsBlock = document.getElementById('elements-block');
  const mediaBlock = document.getElementById('media-block');
  [
    { dom: layoutBlock, name: 'LayoutGroup' },
    { dom: elementsBlock, name: 'ElementGroup' },
    { dom: mediaBlock, name: 'MediaGroup' },
  ].map((item) => {
    Sortable.create(item.dom, {
      group: {
        name: item.name,
        pull: 'clone',
        put: false,
      },
      animation: 150,
      sort: false,
      onEnd: function (/**Event*/ evt) {
        const previewHelper = document.getElementById('previewHelper');
        if (
          dragLocation &&
          previewHelper &&
          dragLocation.childElementCount > 0
        ) {
          document.getElementById('previewHelper').classList.remove('hidden');
        }
      },
    });
  });
}

defineBlocksDragAndDrop();

Sortable.create(dragLocation, {
  group: {
    name: 'ContentGroup',
    put: ['LayoutGroup', 'ElementGroup', 'MediaGroup'],
  },
  filter: '.unsortable',
  animation: 0,
  onAdd: function (/**Event*/ evt) {
    console.log('we are ontest');
    const preview = document.querySelector('#previewHelper');
    customEventCreator('droppedElementServerNotification', evt.item, {
      index: preview && evt.newIndex === 1 ? 0 : evt.newIndex,
      type: evt.item.dataset.type,
      parent_type: evt.to.dataset.parentType,
      parent: evt.to.dataset.type,
      parent_id: evt.to.id,
    });
    evt.item.remove();
  },
  onUpdate: function (/**Event*/ evt) {
    customEventCreator('changeElementOrderServerNotification', evt.item, {
      id: evt.item.dataset.id,
      new_index: evt.newIndex,
      type: evt.item.dataset.type,
      parent_type: evt.to.dataset.parentType,
      parent_id: evt.to.id,
    });
  },
});

Sortable.create(previewHelper, {
  group: {
    name: 'previewHelper',
    put: ['LayoutGroup'],
  },
  animation: 150,
  sort: false,
  onChange: function (/**Event*/ evt) {
    if (
      dragLocation.childElementCount === 1 ||
      dragLocation.childElementCount === 0
    ) {
      previewHelper.classList.add('hidden');
    }
  },
});

// Start Hooks object
let Hooks = {};

// Start hooks Functions, this place we put some hooks we defined in elixir side and communicate with backend
Hooks.dragAndDropLocation = {
  mounted() {
    // This is a simple way based on JS Listener
    const liveView = this;
    this.el.addEventListener('droppedElementServerNotification', (e) => {
      e.preventDefault();
      // send back to the server
      this.pushEvent('create', e.detail);
    });

    this.el.addEventListener('changeElementOrderServerNotification', (e) => {
      e.preventDefault();
      // send back to the server
      this.pushEvent('order', e.detail);
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

    this.handleEvent('create_draggable', ({ id }) => {
      const element = document.getElementById(id);
      Sortable.create(element, {
        group: {
          name: `${id}-Sortable`,
          put: ['LayoutGroup', 'ElementGroup', 'MediaGroup'],
        },
        filter: '.unsortable',
        animation: 150,
        onAdd: function (/**Event*/ evt) {
          evt.item.remove();
          if (evt.item.dataset.type !== 'layout') {
            liveView.pushEvent('create', {
              index: evt.newIndex,
              type: evt.item.dataset.type,
              parent_type: evt.item.dataset.parentType,
              parent: evt.to.dataset.type,
              parent_id: evt.to.id,
            });
          }
        },
        onUpdate: function (/**Event*/ evt) {
          liveView.pushEvent('order', {
            id: evt.item.dataset.id,
            new_index: evt.newIndex,
            type: evt.item.dataset.type,
            parent_type: evt.to.dataset.parentType,
            parent_id: evt.to.id,
          });
        },
      });
    });

    this.handleEvent('create_preview_helper', ({ status }) => {
      if (status) {
        Sortable.create(document.getElementById('previewHelper'), {
          group: {
            name: 'previewHelper',
            put: ['LayoutGroup'],
          },
          animation: 150,
          sort: false,
          onChange: function (/**Event*/ evt) {
            if (
              dragLocation.childElementCount === 1 ||
              dragLocation.childElementCount === 0
            ) {
              document.getElementById('previewHelper').classList.add('hidden');
            }
          },
        });
      }
    });

    this.handleEvent(
      'show_selected_results',
      ({ results, id, myself, count }) => {
        const resDOM = document.querySelector(`#${id}`);
        document.querySelector(`#count-${id}`).innerHTML = count;
        resDOM.innerHTML = '';

        results.map((item) => {
          const el = `
        <p class="cursor-pointer px-1 py-1 duration-200 hover:bg-gray-300 hover:rounded-md hover:duration-100 text-black text-sm" phx-click="select" phx-value-config="${item}" phx-target="${myself}" phx-value-myself="${myself}">
          ${item}
        </p>
        `;
          resDOM.innerHTML += el;
        });
      }
    );

    this.handleEvent('set_extra_config', ({ config, id }) => {
      const perConDOM = document.querySelector(
        `.${id}-extra-config-${stateLessConfig}`
      );
      if (config) {
        const conDOM = document.querySelector(`.${id}-extra-config-${config}`);
        perConDOM.classList.remove('bg-gray-200');
        conDOM.classList.add('bg-gray-200');
        stateLessConfig = config;
      } else {
        const conDOM = document.querySelector(`.${id}-extra-config-none`);
        conDOM.classList.remove('bg-gray-200');
        perConDOM.classList.add('bg-gray-200');
      }
    });

    this.handleEvent('get_extra_config', ({ config, myself }) => {
      this.pushEventTo(myself, 'save', {
        extra_config: stateLessConfig,
        config: config,
      });
    });

    this.handleEvent('clean_extra_config', () => {
      stateLessConfig = 'none';
    });

    this.handleEvent('create_sample_html', ({ myself }) => {
      const bodyDOM = document.querySelector('body');
      this.pushEventTo(myself, 'save', {
        html: bodyDOM.innerHTML,
      });
    });

    this.handleEvent('clean_layout_default_style', ({ block_id }) => {
      const layoutDOM = document.getElementById(`${block_id}`);
      layoutDOM.classList.toggle('create-layout');
      layoutDOM.classList.toggle('create-layout-pure');
    });

    this.handleEvent('set_focus', ({ customClasses }) => {
      const formsDOM = document.querySelectorAll(`.${customClasses}`);
      formsDOM.forEach((item) => {
        item.focus();
        item.setSelectionRange(-1, -1);
      });
    });

    this.handleEvent('get_element_parent_id', ({ id, myself }) => {
      const elementDOM = document.getElementById(`${id}`);
      this.pushEventTo(myself, 'set', {
        layout_id: elementDOM.parentNode.id,
      });
    });

    this.handleEvent('redefine_blocks_drag_and_drop', () => {
      defineBlocksDragAndDrop();
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
