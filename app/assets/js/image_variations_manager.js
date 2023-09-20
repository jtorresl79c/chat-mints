// Pass backend variables to js variables
/**
 * VARIABLES AND FUNCTIONS THAT NEED INITIATION
 */
var windowSize = window.innerWidth
this.setBackgrounds(true);

/**
 * EVENT LISTENERS
 */

// Execute something on 575 breakpoint (mobile to desktop and vice versa)
window.addEventListener('resize', function(event) {
    if ((windowSize > 575 && window.innerWidth <= 575) || (windowSize <= 575 && window.innerWidth > 575)) {
        this.setBackgrounds();
    }
    windowSize = window.innerWidth;
}, true);

/**
 * FUNCTIONS
 */

// Get Sections Data and check if it has a background image
function setBackgrounds(setOnError = false) {
    let images = document.querySelectorAll(`img[id^="auto-resize"]`);

    images.forEach(image => {
        let imageSrc = image && image.src ? image.src : null;

        if (imageSrc) {
            let urlWithSize = window.innerWidth <= 575 ? (imageSrc + '?size=mobile') : imageSrc.replace('?size=mobile', '');
            image.src = urlWithSize;
        }

        if (setOnError) image.onerror = recueImage;
    });
}

function recueImage(e) {
    let image = e.target;
    let imageSrc = image.src;
    let mobileSize = '?size=mobile';

    if (imageSrc.includes(mobileSize)) {
        image.src = imageSrc.replace(mobileSize, '');
    }
}