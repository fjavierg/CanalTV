// import the event dispatcher class
import mx.events.EventDispatcher;

// init values
var xml_components_to_load = 0;
var xml_components_loaded = 0;

// intialize event dispatcher
EventDispatcher.initialize(this);
this.addEventListener("containerInit",getContent);
this.addEventListener("xmlInit",getContent);

// create a new array to hold the data
weatherDays = new Array();
var weatherDayIndex = 0;

// event controller function - this function processes all events
function getContent(evt){

	// everything is ready to load RSS data from source
	if(evt.type=="containerInit"){

		// create data provider and begin loading from data source
		contentDP = new XML();
		contentDP.ignoreWhite = 1;
		contentDP.load(feedURL);
		
		// make call to function when the data has completed loading
		contentDP.onLoad = loadRSSWeather;
		xml_components_to_load++;
	}

	if(evt.type=="xmlInit"){
		xml_components_loaded++;
		if(xml_components_loaded==xml_components_to_load){
		}
	}

}

// load the XML from the RSS feed
function loadRSSWeather(){ 
	
	// The following parsing algorithm is made specifically for the Yahoo Weather RSS feed. 
	// The parser looks for the exact path to the weather data we are looking for:
	// 		rss.channel.item.{yweather:condition, yweather:forecast}
	
	xmlData = this.firstChild.firstChild.childNodes;
	todaysWeather = new Weather();

	for(var i=0; i<xmlData.length; i++){
		if(xmlData[i].nodeName=="item"){
			itemData = xmlData[i].childNodes;
			for(var j=0; j<itemData.length; j++){
				if(itemData[j].nodeName.indexOf("weather")>0){
					if(itemData[j].nodeName.indexOf("condition")>0){
						// this is the current conditions
						// attach weatherDay from library and pass all tag attributes from data source						
						obj = _root.attachMovie("weatherDay","todaysWeather",getNextHighestDepth(),itemData[j].attributes);
						weatherDays.push(obj);
					}else if(itemData[j].nodeName.indexOf("forecast")>0){
						// this is part of the forecast
						// attach weatherDay from library and pass all tag attributes from data source						
						obj = _root.attachMovie("weatherDay","forecastWeather_"+j,getNextHighestDepth(),itemData[j].attributes);
						obj._visible = 0;
						weatherDays.push(obj);
					}
				}
			}
		}
	}
	dispatchEvent({type:"xmlInit", target:this});
}

// function to check the next day's weather (and make the appropriate movieclip visible)
function nextWeatherDay(){
	weatherDays[weatherDayIndex]._visible = 0;
	if(++weatherDayIndex>weatherDays.length-1){
		weatherDayIndex = 0;
	}
	weatherDays[weatherDayIndex]._visible = 1;
}

// function to check the prev day's weather (and make the appropriate movieclip visible)
function prevWeatherDay(){
	weatherDays[weatherDayIndex]._visible = 0;
	if(--weatherDayIndex<0){
		weatherDayIndex = weatherDays.length-1;
	}
	weatherDays[weatherDayIndex]._visible = 1;
} 