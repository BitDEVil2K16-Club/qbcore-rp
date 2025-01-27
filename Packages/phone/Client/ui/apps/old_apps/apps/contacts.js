var inputNumber = ''
var contactPagesElm = $('.pages > div')
var contactPages = new Map()
var activePage = $('.contacts--list--page')

contactPagesElm.each((idx, element) => {
    if (element.dataset.page)
        contactPages.set(element.dataset.page, element)
});

var numberDisplay = $('.number--display .number')
var addNumberPrompt = $('.add--number--prompt')

numberDisplay.text(inputNumber)

$('.dial--action').click(e => {
    inputNumber = inputNumber + e.target.dataset.number;

    numberDisplay.text(inputNumber)
})

$('.cancel--action').click(e => {
    inputNumber = inputNumber.slice(0, inputNumber.length - 1)
    numberDisplay.text(inputNumber)
})

$('.nav--item').click(e => {
    var item = e.target.closest('.nav--item')
    activePage.hide()    
    $('.nav--item.selected').removeClass('selected')        
    
    $(item).addClass('selected') 
    
    console.log(e.target)
    var pageElem = contactPages.get(item.dataset.target)
    console.log(pageElem)
    activePage = $(pageElem)
    activePage.show()
})