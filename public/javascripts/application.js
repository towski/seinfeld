window.addEvent('domready', function(){
  $$('table.calendar td').each(function(day){
    if(day.className.indexOf('progressed') > -1) {
      var x = new Element('div', {'class': 'xmarksthespot ' + ["x-1", "x-2", "x-3"].getRandom() });
      day.appendChild(x);
    }
  })
});