function set_timeline(e,n){var a=JSON.parse(window.calendar.replace(/&quot;/gi,'"')),o=JSON.parse(window.items.replace(/&quot;/gi,'"')),c=window.json;for(i in o)o[i].link&&(o[i].link=o[i].link.replace("academico/item","academico/timeline/"+e));header(c,o,a.half,function(){body(o),events(o)},n)}