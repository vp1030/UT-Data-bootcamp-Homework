// set html elements to variables
var $tbody = document.querySelector("tbody");

var $dateInput = document.querySelector("#date");
var $cityInput = document.querySelector("#city");
var $stateInput = document.querySelector("#state");
var $countryInput = document.querySelector("#country");
var $shapeInput = document.querySelector("#shape");

var $searchBtn = document.querySelector("#search");
var $resetBtn = document.querySelector("#reset");

var $recordCounter = document.querySelector("#recordCounter");
var $pages = document.querySelector("pages");
var $loadBtn = document.querySelector("#load");
var $nextBtn = document.querySelector("#next");
var $prevBtn = document.querySelector("#prev");

// create EventListeners for buttons when clicked
$searchBtn.addEventListener("click", handleSearchButtonClick);
$resetBtn.addEventListener("click", handleResetButtonClick);
$nextBtn.addEventListener("click", handleNextButtonClick);
$prevBtn.addEventListener("click", handlePrevButtonClick);
$pages.addEventListener("click", handlePagesChange);

// set the dataSet to a variable to be filtered
var filteredData = dataSet;
var count = 0;

// define event handler functions

//handleNextButtonClick func increments count and renders
function handleNextButtonClick() {
    count++;
    renderTable();    
}

//handlePrevButtonClick function decrement the count and renders
function handlePrevButtonClick(){
    count--;
}

// handlePageChange renders for new record count selected
function handlePageChange() {
    renderTable();
}

// filters dataSet according to input from search fields
function handleSearchButtonClick() {

    // set input fields to variables
    var filterDate = $dateInput.value.trim();
    var filterCity = $cityInput.value.trim().toLowerCase();
    var filterState = $stateInput.value.trim().toLowerCase();
    var filterCountry = $countryInput.value.trim().toLowerCase();
    var filterShape = $shapeInput.value.trim().toLowerCase();

    // check for values and filter dataSet if found
    if (filterDate != "") {
        filteredData = filteredData.filter(function(date) {    
            var dataDate = date.datetime;
            return dataDate === filterDate;
    });
}
    if (filterCity != "") {
        filterCity = filteredData.filter(function(city) {    
            var dataCity = city.city;
            return dataCity === filterCity;
    });
}        
    if (filterState != "") {
        filterState = filteredData.filter(function(state) {    
            var dataState = state.state;
            return dataState === filterState;
    });
}
    if (filterCountry != "") {
        filterCountry = filteredData.filter(function(country) {    
            var dataCountry = country.country;
            return dataCountry === filterCountry;
    });
}
    if (filterShape != "") {
        filterShape = filteredData.filter(function(shape) {    
            var dataShape = shape.shape;
            return dataShape === filterShape;
    });
}

renderTable();
}

// define renderTable() function
function renderTable() {
    // clear previously rendered table
    $tbody.innerHTML = "";

    // get number o frecords to be rendered
    var pages = Number(document.getElementById("pages").value);

    // initialze local variables

    var start = count * page + 1;
    var end = count * page -1;
    var btn;

    // adjust records displayed for end of data and state of 'next' button
    if (end > filteredData.length) {
        end = filteredData.lenght;
        btn = document.getElementById("next");
        btn.disabled = true;
    }
    else {
        btn = documnet.getElementById("next");
        btn.disabled = false;     
    } 

    // adjust state of 'previous' button
    if (start == 1) {
        btn = document.getElementById("prev");
        btn.disabled = true;
    }
    else {
        btn = document.getElementById("prev");
        btn.disabled = flase;
    }

    // display record counts and loads records into table

    $recordCounter.innerText = "From Record: " + start + "to" + end + "of" + filteredData.length;
    // outer loop loads specified number of records
    for (i = 0; i<pages; i++){
        var item = filteredData[i + (count * pages)];
        var fields = Object.keys(item);
        var row = $tbody.insertRow(i);
        // inner loop loads fields into the table
        for (var j = 0; j<fileds.length; j++) {
            var field = fields[j];
            var cell = $row.insertCell(j);
            $cell.innerText = item[field];
        }
    }



// reset the table for a new search
function handleResetButtonClick() {
    
    // clear the input fields
    $dateInput.value = "";
    $cityInput.value = "";
    $stateInput.value = "";
    $countryInput.value = "";
    $shapeInput.value = "";
    
    // reset filteredData to the full dataSet
    filteredData = dataSet;
    
    renderTable();
}

// render the full table on page load
renderTable();