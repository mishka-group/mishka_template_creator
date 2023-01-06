const layoutBlock = document.getElementById('layoutBlock');
const dragLocation = document.getElementById('dragLocation');
const previewHelper = document.getElementById('previewHelper');
const sortableSpeed = 150;

// Helper functions
export function recoverAndConvertAfterDroppingAnItem(htmlElement, elementID) {
  liveViewAttributeRemover(htmlElement);
  htmlElement.setAttribute('id', `${elementID}-clone-${uuidv4()}`);
  htmlElement.setAttribute('data-type', elementID);
  const blockCodeID = document.querySelector(`[data-id="${elementID}"]`);
  blockCodeID.setAttribute('id', elementID);
}

export function liveViewAttributeRemover(htmlElement) {
  ['data-id', 'phx-click', 'phx-hook'].map((item) => {
    htmlElement.removeAttribute(item);
  });
}

export function customEventCreator(name, htmlElement, params) {
  // It is a custom listener to let Phoenix LiveView hook, something happened that it should be listen.
  const event = new CustomEvent(name, {
    bubbles: true,
    detail: params,
  });
  // This is a sender and dispatcher for event
  htmlElement.dispatchEvent(event);
}

export function uuidv4() {
  try {
    return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c) =>
      (
        c ^
        (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
      ).toString(16)
    );
  } catch (e) {
    const randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
    return randLetter + Date.now();
  }
}

export { layoutBlock, dragLocation, previewHelper, sortableSpeed };