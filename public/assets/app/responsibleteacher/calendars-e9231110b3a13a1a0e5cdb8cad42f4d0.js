if($(function(){$(".go").on("click",function(){window.location.href="/responsavel/calendarios/"+$("[name=year]").val()+"/"+$("[name=half]:checked").val()+"/"+$("[name=tcc]:checked").val()});var e='<a href="/responsavel/calendarios/{{year-half}}/{{tcc}}">{{text}}</a>',a=new Date,n=a.getFullYear();if(a.getMonth()<=5)var r=n+"/1",c=n+"/2";else var r=n+"/2",c=n+1+"/1";for(var l=1;2>=l;l++){var o=e.replace("{{year-half}}",r).replace("{{tcc}}",l).replace("{{text}}","TCC "+l+" deste semestre");$(".links").append(o),o=e.replace("{{year-half}}",c).replace("{{tcc}}",l).replace("{{text}}","TCC "+l+" do pr\xf3ximo semestre"),$(".links").append(o)}}),window.calendar&&window.items){var calendar=JSON.parse(window.calendar.replace(/&quot;/gi,'"')),items=JSON.parse(window.items.replace(/&quot;/gi,'"')),json=window.json;header(json,items,calendar.half,function(){body(items)}),$("#save").on("click",function(){var e=JSON.stringify(canvas.toJSON(["event_id","fill"]));$.post("/responsavel/calendarios/"+calendar.id+"/timeline/save",{json:e},function(e){e=JSON.parse(e),alert(1==e.response?"Timeline foi salva com sucesso!":"Ops, algo errado aconteceu!")})})}