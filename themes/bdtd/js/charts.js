/**********************************************************************************
******************************** VARIAVEIS GLOBAIS ********************************/

var dados;
var listInsti = [];
var limitSelec = 1;
/**************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************/






/**********************************************************************************
***********************************************************************************/


/**********************************************************************************
******************************** FUNÇÕES ********************************/

function montaURLAPI(instSelec, facet){ 
	url = ''
	if(instSelec.size() > 0){	
		// MONTA URL PARA FACET
		if(facet){
			//url = '/vufind/api/v1/search?type=AllFields&facet[]=institution&lookfor=institution%3A'//%20' //RCAAP&facetFilter[]=institution%3A%20UNICAMP&page=1&limit=0
			url = '/vufind/api/v1/search?type=AllFields&facet[]=institution&lookfor=institution%3A'
	      	
	      	for( var i =0; i <  instSelec.size(); i++){
	      		
	      		// PEGANDO O NOME DA INSTITUIÇÃO SELECIONADA
	      		url += $(instSelec[i]).text();
	      		
	      		// VERIFICANDO SE HÁ MAIS DE UMA INSTITUIÇÃO SELECIONADA PARA MONTAR A URL
	      		if($(instSelec[i+1]).text() != ''){      			
	      			url += '%20OR%20institution%3A'
	      		}else{      			
	      			url += '&page=1&limit=0'
	      		}
	      	}
		}else{ // MONTA URL PARA RECUPERAR DADOS EM GERAL DAS INSTITUIÇÕES
			url = '/vufind/api/v1/search?type=AllFields&facet[]=institution&lookfor=institution%3A' //RCAAP&facetFilter[]=institution%3A%20UNICAMP&page=1&limit=0

	      	for( var i =0; i <  instSelec.size(); i++){
	      		
	      		// PEGANDO O NOME DA INSTITUIÇÃO SELECIONADA
	      		url += $(instSelec[i]).text();
	      		
	      		// VERIFICANDO SE HÁ MAIS DE UMA INSTITUIÇÃO SELECIONADA PARA MONTAR A URL
	      		if($(instSelec[i+1]).text() != ''){      			
	      			url += '%20OR%20institution%3A'
	      		}else{      			
	      			url += '&page=1&limit=0'
	      		}
	      	}
		}
	}
	
	return url;
}

// FUNÇÃO PARA RETORNAR UMA FUNÇÃO COM PROPERTYNAME.
// UTILIZADA PARA CRIAR O GROUPBY DINAMICAMENTE
function createNestingFunction(propertyName){
	return function(d){ 
    	return d[propertyName];
    };
}


/** FUNÇÃO PARA FAZER GROUPBY DINAMICAMENTE. 
PARAMETROS: dados-ARRAY COM OS DADOS A SEREM AGRUPADOS; levels-CAMPOS DO ARRAY QUE SERÃO AGRUPADOS **/
function group(dados,levels){
	// CRIANDO OBJETO DO TIPO 'nest()'
	var nest = d3.nest();

	//LOOP PARA CRIAR AS 'KEYs' DINAMICAMENTE PARA O GROUPBY
	for (var i = 0; i < levels.length; i++) {        
        nest = nest.key( createNestingFunction(levels[i]) );        
	}
	var groupBy = nest.rollup(function(v) { return v.length; }).entries(dados);
	
	groupBy = JSON.parse(JSON.stringify(groupBy).split('"value":').join('"count":'));//ALTERAR NOME DOS ATRIBUTOS DO JSON
	groupBy = JSON.parse(JSON.stringify(groupBy).split('"key":').join('"value":')); //ALTERAR NOME DOS ATRIBUTOS DO JSON

    return groupBy;
}


// FUNÇÃO PARA MONTAR MULTISELECT COM PLUGIN 'multiSelect Jquery'
function montaSearchble(){
  $('.searchable').multiSelect({    
    selectableHeader: "<input type='text' class='search-input' autocomplete='off' placeholder='Selecione a instituição para inserir'>",
    selectionHeader: "<input type='text' class='search-input' autocomplete='off' placeholder='Retirar a instituição do gráfico'>",
    afterInit: function(ms){
      var that = this,
          $selectableSearch = that.$selectableUl.prev(),
          $selectionSearch = that.$selectionUl.prev(),
          selectableSearchString = '#'+that.$container.attr('id')+' .ms-elem-selectable:not(.ms-selected)',
          selectionSearchString = '#'+that.$container.attr('id')+' .ms-elem-selection.ms-selected';
      
      that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
      .on('keydown', function(e){
        if (e.which === 40){
          that.$selectableUl.focus();
          return false;          
        }
      });

      that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
      .on('keydown', function(e){
        if (e.which == 40){          
          that.$selectionUl.focus();
          return false;
        }
      });
    },
    afterSelect: function(){
      this.qs1.cache();
      this.qs2.cache();
      $('#row-2 > #loading').show();
      
      var qtdSelec = $('.ms-selection').find('.ms-list > .ms-elem-selection.ms-selected');
      
      d3.selectAll("#row-2 > #charts > *").empty();
      d3.selectAll("#row-2 > #charts > *").remove();



      if(qtdSelec.length == limitSelec){
        $('.ms-selectable').find("*").prop('disabled', true);
        alert('Limite de instuições é de ' + limitSelec)
      }

      url = montaURLAPI(qtdSelec, true)
      
      //console.log(url)
      //teste()
      multIns({inst: $(qtdSelec).text()})
      //readApiFacet("#row-2","Quantidade de Documentos por Instituição", url);
    },
    afterDeselect: function(){
      this.qs1.cache();
      this.qs2.cache();
      var qtdSelec = $('.ms-selection').find('.ms-list > .ms-elem-selection.ms-selected')

	  d3.selectAll("#row-2 > #charts > *").empty();
      d3.selectAll("#row-2 > #charts > *").remove();

      if(qtdSelec.length < limitSelec){
        $('.ms-selectable').find("*").prop('disabled', '');
      }            
      //url = montaURLAPI(qtdSelec, true)

      //multIns({inst: $(qtdSelec).text()})

      //readApiFacet("#row-2","Quantidade de Documentos por Instituição", url);
      // CHAMAR FUNÇÃO PARA BUSCAR INSTITUIÇÕES SELECIONADAS A CADA SELEÇÃO
    }
  });
}

// MONTA COMBO DAS INSITITUIÇÕES DA BASE
function montaCombo (){
  d3.json('/vufind/api/v1/search?type=AllFields&facet[]=institution&sort=relevance&page=1&limit=0&prettyPrint=false&lng=en', function(error, data){
    if(error) throw error;

    var facet = Object.keys(data.facets)
    var dados = data.facets[facet]

    dados.sort(function(x, y){        
        return d3.ascending(x.value, y.value);
    })

    $.each(dados, function(x,y){
      $('#comboInst').append($('<option>',{
        value: y.value,
        text: y.value
      }))      
    })    
    montaSearchble();
    $('.ms-list').css("height",'125px')
  })
}

function createDiv(titleDiv){
    var divGraph = d3.select("body .wrapper #content")
                  .append("div")
                    .style("width", "50%")
                    .style("float", "right")
                    .attr("class","teste");

    divGraph.append("div")
      .attr("class", "titleDiv")
      .append("h2")
        .text(titleDiv)

    divGraph.append("div")
      .attr("class", "grafico");
      
    return divGraph;
}

// FUNÇÃO PARA LER DADOS DA API EM FORMATO FACE
function readApiFacet(id,titleDiv,url){
    d3.json(url, function(error, data) {
      if (error) throw error;
      
      var facet   = Object.keys(data.facets);
      var formats = data.facets[facet].slice(0,10);

      formats.sort(function(x, y){        
        return x.value - y.value;
      })

      //CHAMANDO FUNÇÃO PARA INSERIR OS GRÁFICOS NA PÁGINA
      barGraph(id, titleDiv,formats);
    });
}


function barGraph(id,titleDiv,data){
    
    var div = d3.select(id)
              .append("div")
              .attr("class", "col-sm-6 borderDiv")
              

    var margin = {top: 20, right: 20, bottom: 105, left: 50},
        width  = 550 - margin.left - margin.right,
        height = 400 - margin.top - margin.bottom;

    var title = div.append("h2")
                  .text(titleDiv);

    var x = d3.scaleBand().range([0, width]).padding(0.1),
        y = d3.scaleLinear().rangeRound([height, 0]);

    var svg = div.append("svg")
             .attr("width", "100%")
             .attr("height", "400")

    var g = svg.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  	data.sort(function(x, y){        
  		return x.value - y.value;
  	})

  	x.domain(data.map(function(d) { return d.value; }));
  	y.domain([0, d3.max(data, function(d) { return d.count; })]);

  	g.append("g")
  	  .attr("class", "axis axis--x")
  	  .attr("transform", "translate(0," + height + ")")
  	  .call(d3.axisBottom(x))
  	.selectAll("text")
  	  .style("text-anchor", "end")
  	  .style("font-size", "11px")
  	  .attr("dx", "-.8em")
  	  .attr("dy", ".8em")
  	  .attr("transform", "translate(0,0) rotate(-40)" ); //rotate(-30,16,-25)

  	g.append("g")
  	  .attr("class", "axis axis--y")
  	  .call(d3.axisLeft(y).ticks(10,"s"))	  
  	.append("text")
  	  .attr("transform", "rotate(-90)")
  	  .attr("y", 6)
  	  .attr("dy", "0.71em")
  	  .attr("text-anchor", "end")
  	  .text("Frequency");

  	g.selectAll(".bar")
  	.data(data)
  	.enter().append("rect")
  	  .attr("class", "bar")
  	  .attr("x", function(d) { return x(d.value); })
  	  .attr("y", function(d) { return y(d.count); })
  	  .attr("width", x.bandwidth())
  	  .attr("height", function(d) { return height - y(d.count); })	  
  	  .on("mousemove", function(d){
  	        tooltip
  	          .style("left", d3.event.pageX - 50 + "px")
  	          .style("top", d3.event.pageY - 70 + "px")
  	          .style("display", "inline-block")
  	          .html((d.value) + "<br>" + (d.count.toLocaleString('de-DE')));
  	    })
  	  .on("mouseout", function(d){ tooltip.style("display", "none");});
    
}


function ver(data){
	//console.log();
	listInsti.push(data);
	/*var countType = group(listInsti, ['data'])		

		countType.sort(function(x, y){        
			return y.count - x.count ;
		})
	barGraph("#row-1","Quantidade de Docs. por Tipo de Repositório",countType)*/
}

//FUNÇÃO PARA DESENHAR OS EIXOS X e Y
function drawAxix(params){	
	this.append("g")
		.attr("class", "axis axis--x")
		.attr("transform", "translate(0," + params.margins.margins.height + ")")//params.margins.margins.height
		.transition()
		.delay(2000)
		.duration(1500)
		.call(d3.axisBottom(params.axis.x))			
  	.selectAll("text")
		.style("text-anchor", "end")
		.style("font-size", "11px")
		.attr("dx", "-.8em")
		.attr("dy", ".8em")
		.attr("transform", "translate(0,0) rotate(-40)" ); //

  	this.append("g")
		.attr("class", "axis axis--y")		
		.transition()
		.delay(2000)
		.duration(1500)
		.call(d3.axisLeft(params.axis.y).ticks(10,"s"))//params.axis.
}


function barChart(params){
	//var color = d3.scaleOrdinal(d3.schemeCategory20c);
	var scaleColor = d3.scaleSequential(d3["interpolateBlues"]).domain([0, d3.max(params.data, function(d) { return d.count; })]);

	var bar = this.selectAll(".bar")
			  	.data(params.data)
			  	.enter().append("rect")
			  	.classed("hover", true) //CLASSE PARA ATRIBUIR O EFEITO DE MOUSE-OVER
			  	.classed("bar", params.setFill)

	// IF PARA PLOTAR GRÁFICO HORIZONAL ou VERTICAL
	if(params.horizontal){
		params.axis.y.domain(params.data.map(function(d) { return d.value; }));
		params.axis.x.domain([0, d3.max(params.data, function(d) { return d.count; })]);

		bar.attr("x", 0)
			.transition()
				.delay(function(d, i) {
					return i * 100;
				})
			.duration(1500)
			.attr("y", function(d) { return params.axis.y(d.value); })
			.attr("height", params.axis.y.bandwidth() )
			.attr("width", function(d) { return params.axis.x(d.count)})
			.attr("fill", function(d,i){ return scaleColor(d.count)} )
		

	}else{
		params.axis.x.domain(params.data.map(function(d) { return d.value; }));
		params.axis.y.domain([0, d3.max(params.data, function(d) { return d.count; })]);
	
		bar.transition()
			.delay(function(d, i) {
				return i * 100;
			})
			.duration(1500)
			.attr("x", function(d) { return params.axis.x(d.value); })
			.attr("y", function(d) { return params.axis.y(d.count); })
			.attr("width", params.axis.x.bandwidth())
			.attr("height", function(d) { return params.margins.margins.height - params.axis.y(d.count); })//params.margins.margins.margin.height
			.attr("fill", function(d,i){ return scaleColor(d.count)} )

	}
	bar.on("mousemove", function(d){
			tooltip
				.style("left", d3.event.pageX - 50 + "px")
				.style("top", d3.event.pageY - 70 + "px")
				.style("display", "inline-block")
				.html((d.value) + "<br>" + (d.count.toLocaleString('de-DE')));
				//.html('teste tooltip');
		})
		.on("mouseout", function(d){ tooltip.style("display", "none");});

    //DESENHANDO OS LABELS NOS EIXOS X e Y
	drawAxix.call(this, params)
}


function createDiv(params){
	var div = d3.select(params.id)
	          .append("div")
	          .attr("class", params.class)
	div.append("h2")
		.text(params.titleDiv);

	return div;
}





function createSvg(params){
	var svg = this.append("svg")
				.attr('id', params.idSvg)
	    		.attr("width", params.width)
	    		.attr("height", params.height)    		
    
	return svg;
}

function createMargins(params){	
	var medidas = {}
    medidas.margin = {top: params.top, right: params.right, bottom: params.bottom, left: params.left};
	medidas.width  = this.attr('width') - medidas.margin.left - medidas.margin.right;
    medidas.height = this.attr('height') - medidas.margin.top - medidas.margin.bottom;

    return medidas;
}

// FUNÇÃO PARA LER DADOS DA API EM FORMATO FACE
function readApiFacet2(params){
	var g = this

    d3.json(params.url, function(error, data) {
      if (error) throw error;
      
      var facet   = Object.keys(data.facets);
      var formats = data.facets[facet].slice(0,10);

      formats.sort(function(x, y){        
        return x.value - y.value;
      })

      params.data = formats;

      barChart.call(g,params)
      //CHAMANDO FUNÇÃO PARA INSERIR OS GRÁFICOS NA PÁGINA
      
    });
}

// FUNÇÃO PARA INICIALIZAR VARIAVEIS E OBJETOS PARA CRIAR GRÁFICOS
function initVar(params){
	//CRIANDO DIV COM A FUNÇÃO
	var div = createDiv.call(null, {id: params.id, titleDiv: params.titleDiv, class: params.class });

	//CRIANDO SVG COM A FUNÇÃO	
	var svg = createSvg.call(div, {width: params.width, height: params.height, idSvg: params.idSvg});

	//var svg = createSvg.call(div, {width: '500', height: '400'})

	//CRIANDO MARGENS PARA O GRÁFICO
	var margins = createMargins.call(svg, {top: 20, right: 20, bottom: 105, left: 60}),
		margin = margins.margin;

	var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	return {g: g, margins : margins};
}


function pieChar(params){
	var data    = params.data;
	var text    = "";
	var width   = params.margins.margins.width;
	var height  = params.margins.margins.height;
	var opacity = .65;
	var opacityHover = 1;
	var otherOpacityOnHover = opacity;//.7;
	var duration = 1500;
	var delay    = 1000;

	//var radius = Math.min(width-padding, height-padding) / 2;
	var radius = Math.min(width, height) / 1.8;
	var color  = d3.scaleOrdinal(d3.schemeCategory10);

	this.attr('transform', 'translate(' + (width/2.5) + ',' + (height/1.5) + ')')

	var arc = d3.arc()
	            .innerRadius(0)
	            .outerRadius(radius);

    //VARIAVEL PARA AUMENTAR AO PASSAR O MOUSE POR CIMA DA ÁREA
	var arcOver = d3.arc()
				    .innerRadius(0)
					.outerRadius(radius + 10);

	var pie = d3.pie()
	            .value(function(d) { return d.count; })
	            .sort(null);

	var path = this.selectAll('path')
		.data(pie(data))
		.enter()
		.append("g")
		.append('path')
		.classed("pie", true)
		.attr('fill', function(d, i){ return color(d.data.value);} )
		.transition()
		.delay(function(d,i){
			return i * delay;
		})
		.duration(duration)
		.attr('d', arc)
		.style('opacity', opacity)
		.style('stroke', 'white')

		
	d3.selectAll('.pie')
		.on("mousemove", function(d){
			d3.select(this)
				.style("opacity", otherOpacityOnHover);

			d3.select(this)
				.style("opacity", opacityHover)
				.transition()
				.delay(0)
				.duration(500)
				.attr('d', arcOver);

			tooltip
				.style("left", d3.event.pageX - 50 + "px")
				.style("top", d3.event.pageY - 70 + "px")
				.style("display", "inline-block")				
				.html(`${d.data.value} <br> ${d.data.count.toLocaleString('de-DE')}`)
				//(d.count.toLocaleString('de-DE'))
				//.html((d.data.value) + '<br>' + (d.data.count) )
				
		})
		.on("mouseout", function(d){
			d3.select(this)
			    .style("opacity", opacity)
			    .attr('d', arc);

			tooltip.style("display", "none");
		})
		.on("touchstart", function(d) {
		  d3.select("svg")
		    .style("cursor", "none");
		})		
		.each(function(d, i) { this._current = i; });

		//TAMANHO DO RETANGO DA LEGENDA SERÁ 5% DO WIDTH
		var legendRectSize = width * 0.05; //18;
        var legendSpacing = 4;
        var legend = this.selectAll('.legend')                     
						.data(data)                                   
						.enter()                                                
						.append('g')                                            
						.attr('class', 'legend')
						.attr('transform', function(d, i) {                     
							var height = legendRectSize + legendSpacing;          
							var offset = height * color.domain().length / 2;     
							var horz   = width/2.3 - params.margins.margins.margin.right;                       
							var vert   = i * height - offset;                       
							return 'translate(' + horz + ',' + vert + ')';        
						});                                                     


    legend.append('rect')
    	.transition()
		.delay(function(d,i){
			return i * delay;
		})
		.duration(duration)
		.attr('width', legendRectSize)                          
		.attr('height', legendRectSize)                         
		.style('fill', function(d) { return color(d.value); })
		//.style('stroke', color);

    legend.append('text')
    	.transition()
		.delay(function(d,i){
			return i * delay;
		})
		.duration(duration)                
        .attr('x', legendRectSize + legendSpacing)              
        .attr('y', legendRectSize - legendSpacing)              
        .text(function(d) { return d.value + '(' +(d.count.toLocaleString('de-DE')) + ')'; });
}

function boxNumber(params){
	

	var format = d3.format(",d");

	if(params.docs){//BOX COM TOTAL DE DOCUMENTOS
		this.attr('class', 'col-sm-4 borderDiv alert alert-info')

		this.append('span').attr('class', "fa fa-database fa-3x").style('float', 'right')

		var h2 = this.append('h2')
					.text(params.title)

		
		this.append('h4')		
			.transition()
            .duration(1500)
            .on("start", function repeat() {
              d3.active(this)
                .tween("text", function() {
                    var that = d3.select(this),
                        i = d3.interpolateNumber(that.text().replace(/,/g, ""), params.docs.resultCount);
                    return function(t) { that.text(format(i(t))); };
                })
                .transition()
                .delay(2000)
            });
			//.text(params.docs.resultCount.toLocaleString('de-DE'))
	}else if(params.inst){ //BOX COM TOTAL DE INSTITUIÇÕES PARTICIPANTES
		
		this.attr('class', 'col-sm-4 borderDiv alert alert-info')
		this.append('span').attr('class', "fa fa-university fa-3x").style('float', 'right') 

		var h2 = this.append('h2').text(params.title)
		
		this.append('h4').transition()
            .duration(1500)
            .on("start", function repeat() {
              d3.active(this)
                .tween("text", function() {
                    var that = d3.select(this),
                        i = d3.interpolateNumber(that.text().replace(/,/g, ""), params.inst.length);
                    return function(t) { that.text(format(i(t))); };
                })
                .transition()
                .delay(2000)
            });
            //.text(params.inst.length.toLocaleString('de-DE'))		
	}	
}




// VARIAVEL AUXILIAR PARA MONTAR UM NOVO ARRARY 
var element = [];

function getDataSolr(instituições,pag){
	
	$.ajax({
    	type: 'Get',
		dataType: 'jsonp',    	
    	//url: 'http://oasisbr.ibict.br/vufind/api/v1/search?lookfor=institution%3AABEPRO&type=AllFields&field[]=institutions&field[]=publicationDates&sort=relevance&page='+pag+'&limit=100',
    	url:'http://oasisbr.ibict.br/vufind/api/v1/search?lookfor=institution%3AFC%20OR%20institution%3AABCP%20OR%20institution%3AABAU&type=AllFields&field[]=institutions&field[]=publicationDates&sort=relevance&page='+pag+'&limit=100',
//'http://oasisbr.ibict.br/vufind/api/v1/search?lookfor=institution%3AFGV%20OR%20institution%3AFCC&type=AllFields&field[]=institutions&field[]=publicationDates&sort=relevance&page='+pag+'&limit=500',
    	success: function(data){
    		//console.log(data)
    		
    		var campos = Object.keys(data);
    		//console.log(campos.includes('records'));

    		//VERIFICAR SE HÁ DADOS NO RESULTADO
    		if(campos.includes('records')){

    			//INSERINDO OS DADOS EM UM ARRAY
    			var valor = data.records.map(function(object,index){
    							element.push({institution:object.institutions[0], date:object.publicationDates[0]})    							
    						})

    			pag++;// = 1 + pag;

    			getDataSolr('',pag)
    		}else{
    			//console.log(JSON.stringify(d));
    			var dataset = []

    			var g = group(d, ['institution','date']);

    			g.map(function(x,i){
    				var dados = {}
    				//CRIANDO LABEL(key) do array
    				dados.label = x.key;
    				
    				//EACH PARA COLOCAR O ANO COMO KEY E SEUS RESPECTIVOS VALORES
    				$.each(x.values, function(i, x){
    					dados[x.key] = x.value;
    				})    				
    				//ADICIONANDO VALORES NO DATASET FINAL    				
    				dataset.push(dados)
    			})
    			barGraphDouble(dataset)
    		}
    	},
    	error: function(error){
    		console.log(error)
    	}
    });      
    //return d;
}

//getDataSolr('',1);


var dados = []

function imp (data){	
	console.log('imprimir ', data);
	//dados.push(data)
	//barGraphDouble(data)
	//return new Promise(function(){
	//	console.log('imp ', dados);		return 'imp ';
	//})
	//barGraphDouble(dados)
	//return dados;
	
}

var d = []

function teste(){
	var dfd = $.Deferred();
	loop();
	//$.when().done(loop,imp)//, function(resp){		console.log(resp)	})
	//$.when().done(loop,imp(dados))
	//$.when(imp).done(function(ret) { console.log(ret) } ) //loop,barGraphDouble)
	//$.when(loop).done(imp, barGraphDouble)	
	//$.when(loop()).done(imp).done(barGraphDouble)
	//Promise.resolve(loop()).then(function(resp){//console.log(resp)var d = [resp]imp(resp)})
	/*$.when(loop())
	.then(function(resp){
		console.log(resp)
		imp(resp)
	})
	/*
	loop().then(function(resp){
		console.log('resp = ', resp)
		imp(resp)
		return d
	}).then(function(data){
		
	})

	dfd.done(function(x){
		console.log('x = ', x)
	})
	/*
	dfd.resolve()
	dfd.done(function(){
			console.log('resp')
		})
	*/

}

function loop(){
	console.log('loop')
	var retorno = {}
	var inst  = ['BSID', 'Alcar']
	var url;
	
	//return new Promise(function(resp, error){
		inst.forEach(function(i){
			url = "/vufind/api/v1/search?lookfor=institution%3A"
			url = url + i + "&type=AllFields&facet[]=institution&facet[]=language&facet[]=format&facet[]=publishDate&sort=relevance&page=3&limit=0";

			d3.json(url, function(error, data){
				retorno.inst = data.facets.institution[0].value;
				
				var facet = Object.keys(data.facets).filter(function(x){ return x != 'institution' })

				retorno.anos   = []
				retorno.format = []


				data.facets.publishDate.map(function(data){
					retorno.anos.push({[data.value]:data.count})
				})

				data.facets.format.map(function(format){
					retorno.format.push({value: format.value, count: format.count})
				})

				//dados.push(retorno)
				$.when().done(imp(retorno))
				//imp(retorno)
				//$.when(imp(retorno)).done(barGraphDouble(dados))
				//console.log(data.facets)
				//barGraphDouble(dados)
			})
		})
		//barGraphDouble(retorno);
		//resp(retorno);
	//})
}






//FUNÇÃO PARA CRIAR GRAFICO DE BARRA COM MAIS DE UMA CATEGORI(INSTITUIÇÃO)
function barGraphDouble(data){
	console.log('double',dados)

	dados.map(function(x){
		console.log(x)
	})


	var svg = d3.select("svg"),
    margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = +svg.attr("width") - margin.left - margin.right,
    height = +svg.attr("height") - margin.top - margin.bottom,
    g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	var x0 = d3.scaleBand()
	    .rangeRound([0, width])
	    .paddingInner(0.1);

	var x1 = d3.scaleBand()
	    .padding(0.05);

	var y = d3.scaleLinear()
	    .rangeRound([height, 0]);

	var z = d3.scaleOrdinal()
	    .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

	//data = dados
	
	
	//console.log(dados)
	
	var keys = []

	
	
/*
data.map(function(d){
		console.log(d)
	})

	//console.log('chaves',keys)
	//var keys = d3.keys(data[0]).filter(function(key) { return key !== "label"; });	

	x0.domain(data.map(function(d) { return d.label; }));
	x1.domain(keys).rangeRound([0, x0.bandwidth()]);
	y.domain([0, d3.max(data, function(d) { return d3.max(keys, function(key) { return d[key]; }); })]).nice();


	g.append("g")
	.selectAll("g")
	.data(data)
	.enter().append("g")
	  .attr("transform", function(d) { return "translate(" + x0(d.label) + ",0)"; })
	.selectAll("rect")
	.data(function(d) { return keys.map(function(key) { return {key: key, value: d[key]}; }); })
	.enter().append("rect")
	  .attr("x", function(d) { return x1(d.key); })
	  .attr("y", function(d) { return y(d.value); })
	  .attr("width", x1.bandwidth())
	  .attr("height", function(d) { return height - y(d.value); })
	  .attr("fill", function(d) { return z(d.key); })


	g.append("g")
	  .attr("class", "axis")
	  .attr("transform", "translate(0," + height + ")")
	  .call(d3.axisBottom(x0));

	g.append("g")
	  .attr("class", "axis")
	  .call(d3.axisLeft(y).ticks(null, "s"))
	.append("text")
	  .attr("x", 2)
	  .attr("y", y(y.ticks().pop()) + 0.5)
	  .attr("dy", "0.32em")
	  .attr("fill", "#000")
	  .attr("font-weight", "bold")
	  .attr("text-anchor", "start")
	  

	var legend = g.append("g")
	      .attr("font-family", "sans-serif")
	      .attr("font-size", 10)
	      .attr("text-anchor", "end")
	    .selectAll("g")
	    .data(keys.slice().reverse())
	    .enter().append("g")
	      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; })
	      

	legend.append("rect")
	  .attr("x", width - 19)
	  .attr("width", 19)
	  .attr("height", 19)
	  .attr("fill", z);

	legend.append("text")
	  .attr("x", width - 24)
	  .attr("y", 9.5)
	  .attr("dy", "0.32em")
	  .text(function(d) { return d; });
	  */
}

function multIns(params){
	//console.log(params)
	var url = "/vufind/api/v1/search?lookfor=institution%3A" + params.inst + "&type=AllFields&facet[]=institution&facet[]=language&facet[]=format&facet[]=publishDate&"+
			  "facet[]=author_facet&facet[]=dc.subject.por.fl_str_mv&sort=relevance&page=3&limit=0"

	d3.json(url, function(error, data){
		if(error) throw error;

		// BOXER COM A QUATIDADE TOTAL DE DOCUMENTOS DA INSTITUIÇÃO
		var inst = {} 
		inst.resultCount = data.facets.institution[0].count
		
		var div = d3.select('#row-2 > #charts')
					.append('div')
					.attr('id','box')
					.style('margin-right','10px');

		boxNumber.call(div, { docs: inst , title: "Total of Documents: " + params.inst})


		//GRÁFICO DE TRABALHOS POR ANO DA INSTITUIÇÃO
		var date = data.facets.publishDate;
		date.sort(function(x, y){        
			return x.value - y.value;
		})

		var vars = initVar.call(null, {id: '#row-2 > #charts', titleDiv: 'Documents by Year', class: 'col-sm-12 borderDiv', width: '1000', height:'250'})
		var g 	 = vars.g, 
			y 	 = d3.scaleLinear().rangeRound([vars.margins.height,0]),
		    x 	 = d3.scaleBand().range([0, vars.margins.width]).padding(0.1);
		barChart.call(g, {data: date, axis: {x : x, y : y}, margins: vars,horizontal: false, setFill: false});

		//GRÁFICO DE TRABALHOS POR IDIOMA DA INSTITUIÇÃO
		var lang = data.facets.language;
		var vars = initVar.call(null, {id: '#row-2 > #charts', titleDiv: 'By Language', class: 'col-sm-3 borderDiv', width: '300', height: '250'})
		var g 	 = vars.g
		pieChar.call(g, {data: lang, margins: vars})

		//GRÁFICO DE TRABALHOS POR FORMATO DA INSTITUIÇÃO
		var form = data.facets.format;
		var vars = initVar.call(null, {id: '#row-2 > #charts', titleDiv: 'By Format', class: 'col-sm-3 borderDiv', width: '300', height: '250'})
		var g 	 = vars.g		
		pieChar.call(g, {data: form, margins: vars});

		//GRÁFICO DE KEYS WORDS DA INSTITUIÇÃO
		var keys = data.facets['dc.subject.por.fl_str_mv']
		keys.sort(function(x, y){        
			return x.count - y.count;
		})
		keys     = keys.slice(0,10);
		var vars = initVar.call(null, {id: '#row-2> #charts', titleDiv: 'Keys Words (Top 10)', class: 'col-sm-6 borderDiv', width: '450', height: '250'})
		var g 	 = vars.g, 
			x = d3.scaleLinear().rangeRound([0,vars.margins.width]),
	    	y = d3.scaleBand().range([vars.margins.height, 0]).padding(0.1);

		barChart.call(g, {data: keys, axis: {x : x, y : y}, margins: vars,horizontal: true, setFill: false});


		//GRÁFICO DE TRABALHOS POR AUTHOR DA INSTITUIÇÃO
		var author = data.facets.author_facet;
		author.sort(function(x, y){        
			return x.count - y.count;
		})
		author   = author.slice(0,10);
		var vars = initVar.call(null, {id: '#row-2> #charts', titleDiv: 'Authors (Top 10)', class: 'col-sm-12 borderDiv', width: '1000', height: '300'})
		var g 	 = vars.g, 
			y 	 = d3.scaleLinear().rangeRound([vars.margins.height,0]),
		    x 	 = d3.scaleBand().range([0, vars.margins.width]).padding(0.1);
		barChart.call(g, {data: author, axis: {x : x, y : y}, margins: vars,horizontal: false, setFill: false});

        $("#loading").fadeOut('fast');

	})
}



