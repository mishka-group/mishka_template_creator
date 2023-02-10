import Sortable from 'sortablejs';
import {
  uuidv4,
  customEventCreator,
  recoverAndConvertAfterDroppingAnItem,
  previewHelper,
  sortableSpeed,
  layoutBlock as layoutBlockElement,
  dragLocation,
} from './utilities';

// Create main section
export const LayoutGroup = Sortable.create(layoutBlockElement, {
  group: {
    name: 'LayoutGroup',
    pull: 'clone',
    put: false,
  },
  animation: sortableSpeed,
  sort: false,
  onStart: function (evt) {
    previewHelper.classList.add('hidden');
  },
  onEnd: function (evt) {
    if (dragLocation.children.length === 1) {
      previewHelper.classList.remove('hidden');
    } else {
      customEventCreator('awesome', evt.item, { text: 'test params' });
    }
  },
});

export const ContentGroup = Sortable.create(dragLocation, {
  group: {
    name: 'ContentGroup',
    handle: '.handle',
    put: ['LayoutGroup'],
  },
  animation: sortableSpeed,
  swapThreshold: 0.65,
  onAdd: function (/**Event*/ evt) {
    const elementID = evt.item.dataset.id;
    recoverAndConvertAfterDroppingAnItem(evt.item, elementID);
    if (elementID === 'section-drag') {
      createSectionOnSortableJS(evt.item);
    } else {
      evt.item.remove();
    }
  },
});

function createSectionOnSortableJS(htmlElement) {
  console.log(htmlElement.id);

  // TODO: We need to find original converter
  const deletePhx = `[["push",{"event":"delete","value":{"id":"${htmlElement.id}"}}],["show",{"display":null,"time":200,"to":"#delete_confirm","transition":[[],[],[]]}],["show",{"display":null,"time":200,"to":"#delete_confirm-bg","transition":[["transition-all","transform","ease-out","duration-300"],["opacity-0"],["opacity-100"]]}],["show",{"display":null,"time":200,"to":"#delete_confirm-container","transition":[["transition-all","transform","ease-out","duration-300"],["opacity-0","translate-y-4","sm:translate-y-0","sm:scale-95"],["opacity-100","translate-y-0","sm:scale-100"]]}],["focus_first",{"to":"#delete_confirm-content"}]]`;

  htmlElement.innerHTML = `
    <div
      class="flex flex-row justify-start items-center space-x-3 absolute -left-[2px] -top-11 bg-gray-200 border border-gray-200 p-2 rounded-tr-3xl z-10 w-54"
    >
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="mobile_view"
      phx-value-type="${htmlElement.dataset.type}"
      phx-value-id="${htmlElement.id}"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 18.75h3"
      />
    </svg>

    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="dark_mod"
      phx-value-type="${htmlElement.dataset.type}"
      phx-value-id="${htmlElement.id}"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"
      />
    </svg>

    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="settings"
      phx-value-type="${htmlElement.dataset.type}"
      phx-value-id="${htmlElement.id}"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M11.42 15.17L17.25 21A2.652 2.652 0 0021 17.25l-5.877-5.877M11.42 15.17l2.496-3.03c.317-.384.74-.626 1.208-.766M11.42 15.17l-4.655 5.653a2.548 2.548 0 11-3.586-3.586l6.837-5.63m5.108-.233c.55-.164 1.163-.188 1.743-.14a4.5 4.5 0 004.486-6.336l-3.276 3.277a3.004 3.004 0 01-2.25-2.25l3.276-3.276a4.5 4.5 0 00-6.336 4.486c.091 1.076-.071 2.264-.904 2.95l-.102.085m-1.745 1.437L5.909 7.5H4.5L2.25 3.75l1.5-1.5L7.5 4.5v1.409l4.26 4.26m-1.745 1.437l1.745-1.437m6.615 8.206L15.75 15.75M4.867 19.125h.008v.008h-.008v-.008z"
      />
    </svg>

    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="tag"
      phx-value-type="${htmlElement.dataset.type}"
      phx-value-id="${htmlElement.id}"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z"
      />
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M6 6h.008v.008H6V6z"
      />
    </svg>
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
      phx-click="add_separator"
      phx-value-type="${htmlElement.dataset.type}"
      phx-value-id="${htmlElement.id}"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 4.5v15m7.5-7.5h-15"
      />
    </svg>

    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 text-red-600 cursor-pointer"

      phx-click=${deletePhx}

    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0"
      />
    </svg>

    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6 cursor-pointer"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M12 6.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 12.75a.75.75 0 110-1.5.75.75 0 010 1.5zM12 18.75a.75.75 0 110-1.5.75.75 0 010 1.5z"
      />
    </svg>
  </div>
  `;
  htmlElement.className = '';
  htmlElement.classList.add('create-layout');
  htmlElement.classList.add('!p-20');

  Sortable.create(htmlElement, {
    group: {
      name: `section-${uuidv4()}`,
      handle: '.handle',
      put: ['LayoutGroup'],
    },
    animation: sortableSpeed,
    swapThreshold: 0.65,
    onAdd: function (/**Event*/ evt) {
      htmlElement.classList.remove('!p-20');
      const elementID = evt.item.dataset.id;

      recoverAndConvertAfterDroppingAnItem(evt.item, elementID);

      if (elementID === 'section-drag') {
        evt.item.innerHTML = '';
        evt.item.classList.add('create-section');
        Sortable.create(evt.item, {
          group: {
            name: `section-${uuidv4()}`,
            handle: '.handle',
            put: ['LayoutGroup'],
          },
          animation: sortableSpeed,
          swapThreshold: 0.65,
          onAdd: function (/**Event*/ evt) {
            const elementID = evt.item.dataset.id;
            if (elementID === 'section-drag') evt.item.remove();
          },
        });
      } else {
        evt.item.remove();
        if (htmlElement.children.length === 1) {
          htmlElement.classList.add('!p-20');
        }
      }
    },
  });
}

// Helper functions
