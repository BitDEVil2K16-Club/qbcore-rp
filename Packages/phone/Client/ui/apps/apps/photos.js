// Ran when the app opens up, use this to get elements on DOM
const OnAppStart = (e, args) => {
}

// Ran when the app is closed
const OnAppClose = (e, args) => {
}

var GalleryElements = {
    Body: $('.photo-galery'),
    Gallery: $('.photo-galery .content'),
    Preview: $('.photo-galery .photo-slider'),
    CameraButton: $('.galery-actions > button.camera-btn'),
    FavouriteButton: $('.galery-actions > button.favorites-btn'),
    LibraryButton: $('.galery-actions > button.library-btn'),
    Slider: {
        Image: $('.photo-slider > div.picture > img:nth-child(3)'),
        Favourite: $('.photo-slider > div.picture > button.fav'),
        Quit: $('.photo-slider > div.picture > button.quit'),
        Pagination: $('.photo-slider > div.slider-buttons > p') 
    }
}


PhoneStates = {
    InLibrary: 1,
    InFavourites: 2,
}

PhoneModes = {
    ViewingImage: 1,
    Default: 2
}

currentMode = null
currentState = null
currentSelected = null

var favourites = [];

$(window).click(e => {
    var target = e.target

    var libraryButton = target.closest('.galery-actions > button.library-btn')
    if (libraryButton)
    {
        SetActivePage('library')
        return
    }
    var favouriteButton = target.closest('.galery-actions > button.favorites-btn')
    if (favouriteButton)
    {
        SetActivePage('favourites')
        return
    }
    var image = target.closest('img')
    if (image)
    {
        ShowImageDetails(image)
        return
    }

    var quitButton = target.closest('.photo-slider > div.picture > button.quit')
    if (quitButton)
    {
        GalleryElements.Body.removeClass('in-slider')
        return
    }
})

const SetActivePage = state => {
    if (currentMode === PhoneModes.ViewingImage)
    {
        GalleryElements.Body.removeClass('in-slider')
        currentMode = PhoneModes.Default
    }
    
    if (currentSelected)
        currentSelected.removeClass('selected')

    if (state === 'library')
    {
        currentState = PhoneStates.InLibrary;
        currentSelected = GalleryElements.LibraryButton 
        SetupGallery(hardcodedPhotos)
    }
    else if (state === 'favourites')
    {
        currentState = PhoneStates.InFavourites;
        currentSelected = GalleryElements.FavouriteButton
        SetupFavourites(hardcodedPhotos)
    }

    currentSelected.addClass('selected')
}

const SetupGallery = pictures => {
    GalleryElements.Gallery.empty()

    pictures.map(picture => {
        let element = $(`<img src="${picture.url}">`)
        
        element.data('id', picture.id)
        element.data('favourite', picture.favorite)

        GalleryElements.Gallery.append(element);
    });
}

const SetupFavourites = pictures => {
    GalleryElements.Gallery.empty()

    pictures.map(picture => {
        if (!picture.favorite) return;

        let element = $(`<img src="${picture.url}">`)
        
        element.data('id', picture.id)
        element.data('favourite', picture.favorite)
        
        GalleryElements.Gallery.append(element);
    });
}

const ShowImageDetails = img => {
    GalleryElements.Slider.Image.attr('src', img.src)

    img = $(img)

    var isFavourite = img.data('favourite')

    if (isFavourite)
        GalleryElements.Slider.Favourite.addClass('active')
    else
        GalleryElements.Slider.Favourite.removeClass('active')
        
    GalleryElements.Slider.Pagination.html(`${img.data('id')} <span>/ 256</span>`)

    currentMode = PhoneModes.ViewingImage
    GalleryElements.Body.addClass('in-slider')
}


// Galery
const photoGalery = $(".photo-galery");
const galery = photoGalery.find(".content");
const galeryActions = photoGalery.find(".galery-actions button");
const photo = photoGalery.find("img");

// Slider
const sliderGalery = photoGalery.find(".photo-slider");
const favoriteButton = photoGalery.find(".fav");
const closeSlider = photoGalery.find(".quit");
const buttonSlider = photoGalery.find(".slider-buttons button.arrow");

function setSliderData(picture) {
    favoriteButton.removeClass("active");
    picture.favorite ? favoriteButton.addClass("active") : "";
    sliderGalery.find('.picture img').attr('src', picture.url);
    sliderGalery.find('.date').text(picture.date + ", " + picture.time);
    sliderGalery.find('.photo-counter').html(actualPicture + "<span>/ "+persistentPictures.length+"</span>");

    photoGalery.addClass('in-slider');
}

function setPictures(pictures) {
    persistentPictures = pictures;
    galery.empty();
    pictures.forEach(picture => {
        let element = `<img data-id="${picture.id}" src="${picture.url}" alt="">`

        galery.append(element);
    });
    $('.photo-galery .content img').on("click", function () {
        console.log("asd")
        let id = $(this).attr("data-id");
        let picture = persistentPictures.find(picture => picture.id == id);
        actualPicture = id;
        console.log(id)
        setSliderData(picture);
        // setCameraParameter("slider", true);
    });
}


let hardcodedPhotos = [
    {
        id: 1,
        name: "IMG_20200101_000000.jpg",
        date: "01/01/2020",
        time: "00:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 2,
        name: "IMG_20200213_090000.jpg",
        date: "02/13/2020",
        time: "09:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 3,
        name: "IMG_20200315_150000.jpg",
        date: "03/15/2020",
        time: "15:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 4,
        name: "IMG_20200420_200000.jpg",
        date: "04/20/2020",
        time: "20:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 5,
        name: "IMG_20200505_120000.jpg",
        date: "05/05/2020",
        time: "12:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 6,
        name: "IMG_20200610_080000.jpg",
        date: "06/10/2020",
        time: "08:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 7,
        name: "IMG_20200715_100000.jpg",
        date: "07/15/2020",
        time: "10:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 8,
        name: "IMG_20200820_160000.jpg",
        date: "08/20/2020",
        time: "16:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 9,
        name: "IMG_20200925_220000.jpg",
        date: "09/25/2020",
        time: "22:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 10,
        name: "IMG_20201031_190000.jpg",
        date: "10/31/2020",
        time: "19:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 11,
        name: "IMG_20201120_120000.jpg",
        date: "11/20/2020",
        time: "12:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 12,
        name: "IMG_20201205_160000.jpg",
        date: "12/05/2020",
        time: "16:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 13,
        name: "IMG_20210623_080000.jpg",
        date: "06/23/2021",
        time: "08:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 14,
        name: "IMG_20210730_170000.jpg",
        date: "07/30/2021",
        time: "17:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 15,
        name: "IMG_20210815_140000.jpg",
        date: "08/15/2021",
        time: "14:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 16,
        name: "IMG_20210901_110000.jpg",
        date: "09/01/2021",
        time: "11:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 17,
        name: "IMG_20211010_080000.jpg",
        date: "10/10/2021",
        time: "08:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 18,
        name: "IMG_20211125_150000.jpg",
        date: "11/25/2021",
        time: "15:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 19,
        name: "IMG_20211231_220000.jpg",
        date: "12/31/2021",
        time: "22:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 20,
        name: "IMG_20220115_080000.jpg",
        date: "01/15/2022",
        time: "08:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 21,
        name: "IMG_20220222_190000.jpg",
        date: "02/22/2022",
        time: "19:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 22,
        name: "IMG_20220305_120000.jpg",
        date: "03/05/2022",
        time: "12:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 23,
        name: "IMG_20220410_180000.jpg",
        date: "04/10/2022",
        time: "18:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 24,
        name: "IMG_20220520_150000.jpg",
        date: "05/20/2022",
        time: "15:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 25,
        name: "IMG_20220701_100000.jpg",
        date: "07/01/2022",
        time: "10:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 26,
        name: "IMG_20220815_080000.jpg",
        date: "08/15/2022",
        time: "08:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 27,
        name: "IMG_20220920_160000.jpg",
        date: "09/20/2022",
        time: "16:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 28,
        name: "IMG_20221031_210000.jpg",
        date: "10/31/2022",
        time: "21:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 29,
        name: "IMG_20221115_070000.jpg",
        date: "11/15/2022",
        time: "07:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 30,
        name: "IMG_20221231_230000.jpg",
        date: "12/31/2022",
        time: "23:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 31,
        name: "IMG_20230110_100000.jpg",
        date: "01/10/2023",
        time: "10:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 32,
        name: "IMG_20230214_140000.jpg",
        date: "02/14/2023",
        time: "14:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 33,
        name: "IMG_20230321_180000.jpg",
        date: "03/21/2023",
        time: "18:00",
        favorite: false,
        url: "../img/apps/camera/picture_1.png"
    },
    {
        id: 34,
        name: "IMG_20230430_200000.jpg",
        date: "04/30/2023",
        time: "20:00",
        favorite: true,
        url: "../img/apps/camera/picture_1.png"
    }
];
// setPictures(hardcodedPhotos);

SetActivePage('library')
