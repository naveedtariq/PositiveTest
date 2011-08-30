// Created by Kier Simmons June 2010 under The MIT License for open source software
// http://www.opensource.org/licenses/mit-license.php
// Have fun!
	if(!Array.indexOf){
	  Array.prototype.indexOf = function(obj){
	   for(var i=0; i<this.length; i++){
		if(this[i]==obj){
		 return i;
		}
	   }
	   return -1;
	  }
	}
	jQuery.fn.ddBarChart = function(options) {
		
			function setupDrillDown(strID, intDelay, strH, strW, strL) {
				$(strID+ "> .ddchart-chart-final").css("z-index","2");
				$(strID+ "> .ddchart-chart-init").css("z-index","1");
				$(strID+ "> .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("left",strL);
				$(strID+ "> .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("height",strH);
				$(strID+ "> .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("width",strW);
				$(strID+ "> .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("display","block");
				$(strID+ "> .ddchart-chart-final").fadeOut(0 );
				$(strID+ "> .ddchart-chart-final").fadeIn(300, function(){aniDrillDown(strID,intDelay)});
			}
			
			function aniDrillDown(strID,intDelay) {
				$(strID+ " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").animate( {width: "100%",height: "100%",left: "0%"}, intDelay-500, function(){aniCleanUp(strID)});	
			}
			
			function setupDrillUp(strID, intDelay, strH, strW, strL) {
				$(strID+ "> .ddchart-chart-final").css("z-index","1");
				$(strID+ "> .ddchart-chart-init").css("z-index","2");
				$(strID+ "> .ddchart-chart-init > .ddchart-chart-wrapper-sub").animate( {width: strW,height: strH,left: strL}, 1500, function(){ aniDrillUp(strID) } );
				
			}

			function aniDrillUp(strID) {
				$(strID+ "> .ddchart-chart-init").fadeOut(500, function(){aniCleanUp(strID)});
			}

			function aniCleanUp(strID) {
				$(strID+ "> .ddchart-chart-init").css("display","none");
				$(strID+ "> .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("border","none");
			}

			function resizeFonts (strSelector,blnTruncate) {
				intLabelPecent = 100;
				$(strSelector).css('font-size',intLabelPecent+'%');
				intMaxTextLength = parseInt(250/$(strSelector).size());
				intDivHeight = $(strSelector).height();
				intDivWidth = $(strSelector).width();
				strMaxHeightID = "";
				intMaxHeight = 0;
				strMaxWidthID = "";
				intMaxWidth = 0;
				$(strSelector).each(function(index) {
					if ($(this).children('div:first').text().length > intMaxTextLength + 3 && blnTruncate) {
						$(this).children('div:first').text($(this).children('div:first').text().substr(0,intMaxTextLength)+'...');
					}
					if ($(this).children('div:first').height() > intMaxHeight) {
						intMaxHeight = $(this).children('div:first').height();
					}
					if ($(this).children('div:first').width() > intMaxWidth) {
						intMaxWidth = $(this).children('div:first').width();
					}
				});
				while (intLabelPecent > 5 && (intMaxHeight > intDivHeight || intMaxWidth > intDivWidth)) {
					intMaxHeight = 0;
					intMaxWidth = 0;
					intLabelPecent -= 5;
					$(strSelector).css('font-size',intLabelPecent+'%');
					$(strSelector).each(function(index) {
						if ($(this).children('div:first').height() > intMaxHeight) {
							intMaxHeight = $(this).children('div:first').height();
						}
						if ($(this).children('div:first').width() > intMaxWidth) {
							intMaxWidth = $(this).children('div:first').width();
						}
					});
				}
			}

		function buildYAxis (objSettings, strID) {
			///////////////////////////////////////////////////////////////////////////
			// Define Y Axis.  Yes this could me made more efficent.  You do it.     //
			///////////////////////////////////////////////////////////////////////////

			var intMargin = objSettings.margin;
			var intYMax = 0;
			var intYMin = 0;
			var intYStep = 0;
			var intModifier = 1;
			
			for (intValues = 0; intValues < objSettings.chartData.DATA.length; intValues++) {
				intYMax = objSettings.chartData.DATA[intValues][objSettings.chartData.COLUMNS.indexOf('X_BAR_VALUE')] > intYMax ? objSettings.chartData.DATA[intValues][objSettings.chartData.COLUMNS.indexOf('X_BAR_VALUE')] : intYMax;
			}			
	
			if (intYMax <= 100) 
				intModifier = 1;
			else {
				if (intYMax <= 1000) 
					intModifier = 10;
				else {
					if (intYMax <= 10000) 
						intModifier = 100;
					else {
						if (intYMax <= 100000) 
							intModifier = 1000;
						else {
							if (intYMax <= 1000000) 
								intModifier = 10000;
							else {
								intModifier = 100000;
							}
						}
					}
				}
			}
	
			if (intYMax <= 1*intModifier*20) 
				intYStep = intModifier;
			else {
				if (intYMax <= 2*intModifier*20) 
					intYStep = 2*intModifier;
				else {
					if (intYMax <= 5*intModifier*20) 
						intYStep = 5*intModifier;
					else {
						intYStep = 5*intModifier;
					}
				}
			}
			
			intYMax = intYMax + (intYStep - (intYMax % intYStep));
		
			intBarWidth = 100/objSettings.chartData.DATA.length;
			
			
			$(strID + " > .ddchart-y-axis-wrapper").html("");
	
			for (intYLabels = (intYMin+intYStep); intYLabels <= intYMax; intYLabels += intYStep) {
					$(strID + " > .ddchart-y-axis-wrapper").append('<div class="ddchart-y-axis" style="bottom:'+((intYLabels-intYStep)/intYMax)*100+'%; height:'+(intYStep/intYMax)*100+'%; z-index:100; overflow:hidden;"><div style="display:inline">'+intYLabels+'</div></div>');
			}
	
			$(strID + " > .ddchart-y-axis-wrapper > .ddchart-y-axis:odd").addClass(objSettings.yOddClass);
			$(strID + " > .ddchart-y-axis-wrapper > .ddchart-y-axis:even").addClass(objSettings.yEvenClass);
			
			resizeFonts (strID + " > .ddchart-y-axis-wrapper > .ddchart-y-axis",true);
			return intYMax;
		}
		
		function buildXAxis (objSettings, strID) {
			///////////////////////////////////////////////////////////////////////////
			// Define X Axis.  Yes this could me made more efficent.  You do it.     //
			///////////////////////////////////////////////////////////////////////////
		
			$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-wrapper-sub").html('');
			
			for (intLabels = 0; intLabels < objSettings.chartData.DATA.length; intLabels++) {
				$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-wrapper-sub").append('<div class="ddchart-x-axis" style="left:'+intBarWidth*intLabels+'%; width:'+intBarWidth+'%;"><div class="x-axis-text" style="display:inline" title="'+objSettings.chartData.DATA[intLabels][objSettings.chartData.COLUMNS.indexOf('X_BAR_LABEL')]+'">'+objSettings.chartData.DATA[intLabels][objSettings.chartData.COLUMNS.indexOf('X_BAR_LABEL')]+'</div></div>');
			}
	
			$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-wrapper-sub > .ddchart-x-axis:odd").addClass(objSettings.xOddClass);
			$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-wrapper-sub > .ddchart-x-axis:even").addClass(objSettings.xEvenClass);
			
			
			resizeFonts (strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-wrapper-sub > .ddchart-x-axis",true);

		}
		
		function buildBreadCrumbs (objSettings, strID) {
			///////////////////////////////////////////////////////////////////////////
			// Define Context.                                                       //
			///////////////////////////////////////////////////////////////////////////
			if (objSettings.chartContext != "") {
				$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div").html(objSettings.chartContext);
			}
			else {
				if (objSettings.action != 'drillup'  && objSettings.action != 'jumpback') {
					if (objSettings.chartData.COLUMNS.indexOf('CONTEXT') > -1) {
						if ($(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div").html() != "") 
							strBeginText = " &gt; ";
						else			
							strBeginText = "";
						$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div ").append("<span class='dd-chart-context' chartParentID='"+strID+"'>"+strBeginText+objSettings.chartData.DATA[0][objSettings.chartData.COLUMNS.indexOf('CONTEXT')]+"</span>");
					
						$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div > .dd-chart-context:last").data("drillDataObject",objSettings.chartData);
					}
				}
				if (objSettings.chartData.COLUMNS.indexOf('CONTEXT') > -1) {
					var intTotalCrumbs = $(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div > .dd-chart-context").size();
					var intCrumbCounter = 1;
					$(strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div > .dd-chart-context").each(function(index) {
						$(this).attr('id','ddchart-crumb'+(intTotalCrumbs - intCrumbCounter));
						if (intTotalCrumbs == intCrumbCounter) {
								$(this).unbind('click');
								$(this).attr('title','');
								$(this).removeClass('dd-chart-context-drillup');
								if(jQuery.tooltip) {
									objTooltipSettings = objSettings.tooltipSettings;
									objTooltipSettings.extraClass = 'dd-chart-tooltip '+objTooltipSettings.extraClass.replace('dd-chart-tooltip ','');
									$(this).tooltip(objTooltipSettings);
								}

						}
						else {
							$(this).removeClass('dd-chart-context-drillup').addClass('dd-chart-context-drillup');
							$(this).attr('backTrack',(intTotalCrumbs - intCrumbCounter));
							$(this).attr('drillAction','jumpback');
							//Drill up
							if (intTotalCrumbs - intCrumbCounter == 1) {
								$(this).attr('drillAction','drillup');
								if (objSettings.action == 'drilldown') {
									$(this).attr('barlabel',objSettings.drillLabel);
									$(this).attr('title',objSettings.drillLabel+objSettings.tooltipSettings.showBody);
									if(jQuery.tooltip) {
										objTooltipSettings = objSettings.tooltipSettings;
										objTooltipSettings.extraClass = 'dd-chart-tooltip '+objTooltipSettings.extraClass.replace('dd-chart-tooltip ','');
										$(this).tooltip(objTooltipSettings);
									}

									$(this).unbind('click').click(function() {
										for (intBackTracker = 1; intBackTracker <= $(this).attr('backTrack'); intBackTracker++) {
											$($(this).attr('chartParentID') + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label > div > .dd-chart-context:last").remove();
										}
										objContextDrillSettings = $($(this).attr('chartParentID')).data('ddSettings');
										if (typeof($(this).attr('chartDataLinkURL')) == "undefined") {
											objContextDrillSettings.chartData = $(this).data('drillDataObject');
											objContextDrillSettings.chartDataLink = "";
										}
										else {
											objContextDrillSettings.chartData = {};
											objContextDrillSettings.chartDataLink = $(this).attr('chartDataLinkURL');
										}
										objContextDrillSettings.action = $(this).attr('drillAction');
										if ($(this).attr('drillAction') == "drillup") {
											objContextDrillSettings.drillLabel = $(this).attr('barlabel');
										}
										else {
											objContextDrillSettings.drillLabel = "";
										}

										$($(this).attr('chartParentID')).ddBarChart(objContextDrillSettings);
									});
								}
							}
						}
						intCrumbCounter++;
					 });
				}	
			}
			resizeFonts (strID + " > .ddchart-x-axis-wrapper > .ddchart-x-axis-label",true);
		}

		function buildChart (objSettings, strID, intYMax) {
			///////////////////////////////////////////////////////////////////////////
			// Define Chart.                                                         //
			///////////////////////////////////////////////////////////////////////////
			intMargin = objSettings.margin;
			IntBarWidth = 100/objSettings.chartData.DATA.length;
	
			$(strID + " > .ddchart-chart-final").html('<div class="'+objSettings.chartWrapperClass+' ddchart-chart-wrapper-sub"></div>');
			
			strBGColor = "";
			strToolTipTitle = "";
			strDrillLink = "";
			for (intBars = 0; intBars < objSettings.chartData.DATA.length; intBars++) {
				if (objSettings.chartData.COLUMNS.indexOf('X_BAR_COLOR') >= 0) {
					strBGColor = "background-color:"+objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('X_BAR_COLOR')]+";";
				}
				if (objSettings.chartData.COLUMNS.indexOf('TOOL_TIP_TITLE') >= 0) {
					strToolTipTitle = 'title="'+objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('TOOL_TIP_TITLE')]+objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('X_BAR_VALUE')]+'"';
				}
				if (objSettings.chartData.COLUMNS.indexOf('DRILL_LINK') >= 0) {
					strDrillLink = 'drilllink="'+objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('DRILL_LINK')]+'"';
				}

				$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").append('<div class="'+objSettings.chartBarClass+' ddchart-chart" '+strToolTipTitle+strDrillLink+' barlabel="'+objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('X_BAR_LABEL')]+'" style="left:'+((intBarWidth*intBars)+(intMargin/2))+'%; height:'+((objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('X_BAR_VALUE')]/intYMax)*100)+'%; width:'+(intBarWidth-intMargin)+'%;'+strBGColor+'" chartParentID="'+strID+'">&nbsp;</div>');


			//////////////////////////////////////////////////////////////////////////
			// What to do if the DRILL_DATA column is being used                    //
			//////////////////////////////////////////////////////////////////////////
				if (objSettings.chartData.COLUMNS.indexOf('DRILL_DATA') > -1) {
					$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart:last").data("drillDataObject",objSettings.chartData.DATA[intBars][objSettings.chartData.COLUMNS.indexOf('DRILL_DATA')]);
				}
			}
			
			if (objSettings.chartData.COLUMNS.indexOf('DRILL_DATA') > -1) 
				$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart").click(function() {
					objBarDrillSettings = $($(this).attr('chartParentID')).data('ddSettings');
					objBarDrillSettings.chartData = $(this).data('drillDataObject');
					objBarDrillSettings.action = 'drilldown';
					objBarDrillSettings.drillLabel = $(this).attr('barlabel');
					$($(this).attr('chartParentID')).ddBarChart(objBarDrillSettings);
				});
			else 
				if (objSettings.chartData.COLUMNS.indexOf('DRILL_LINK') > -1) 
						$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart").click(function() {
							objBarDrillSettings = $($(this).attr('chartParentID')).data('ddSettings');
							objBarDrillSettings.chartDataLink = $(this).attr('drilllink');
							objBarDrillSettings.action = 'drilldown';
							objBarDrillSettings.drillLabel = $(this).attr('barlabel');
							$($(this).attr('chartParentID')).ddBarChart(objBarDrillSettings);
						});

			if (objSettings.chartData.COLUMNS.indexOf('TOOL_TIP_TITLE') > -1) {
				if(jQuery.tooltip) {
					objTooltipSettings = objSettings.tooltipSettings;
					objTooltipSettings.extraClass = 'dd-chart-tooltip '+objTooltipSettings.extraClass;
					$(strID + ' > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart').tooltip(objTooltipSettings);
				}

			}
			$(strID + ' > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart').hover(
				function() {$(this).addClass(objSettings.chartBarHoverClass);},
				function() {$(this).removeClass(objSettings.chartBarHoverClass);}
			);
			
			if (objSettings.action == "drilldown") {
					strDrillToHeight = $(strID + " > .ddchart-chart-init > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('height');
					strDrillToWidth = $(strID + " > .ddchart-chart-init > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('width');
					strDrillToLeft = $(strID + " > .ddchart-chart-init > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('left');
					setupDrillDown(strID, objSettings.animationDelay, strDrillToHeight, strDrillToWidth, strDrillToLeft);
			}
			else {
				if (objSettings.action == "drillup") {
					$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("border","none");				
					$(strID + " > .ddchart-chart-init > .ddchart-chart-wrapper-sub").css("border","2px solid black");
					strDrillToHeight = $(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('height');
					strDrillToWidth = $(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('width');
					strDrillToLeft = $(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub > .ddchart-chart[barlabel='"+objSettings.drillLabel+"']").css('left');
	
					setupDrillUp(strID, objSettings.animationDelay, strDrillToHeight, strDrillToWidth, strDrillToLeft);
				}
				else {
					$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("border","none");
					$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").css("height","0%");
					$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").animate( {height: "100%"}, objSettings.animationDelay-500);	
				}
			}
		}
		
		function setupChart (objSettings, strID) {
			if (objSettings.action == "init") 
				$(strID).data("drillDataObject",objSettings.chartData);
			else {	
				$(strID + " > .ddchart-chart-final > .ddchart-chart-wrapper-sub").stop(false,true);
				$(strID + " > .ddchart-chart-init > .ddchart-chart-wrapper-sub").stop(false,true);
				$(strID + " > .ddchart-chart-init").stop(false,true);
			}
			if (objSettings.action == "drilldown" || objSettings.action == "drillup" ) {
				$(strID + " > .ddchart-chart-init").remove();
				$(strID + " > .ddchart-chart-final").addClass("ddchart-chart-init").removeClass("ddchart-chart-final");
				$(strID).append('<div class="ddchart-chart-wrapper ddchart-chart-final"></div>');
			}
			else {
				if (objSettings.action == "jumpback") {
					$(strID + " > .ddchart-chart-init").remove();
					$(strID + " > .ddchart-chart-final").remove();
					$(strID).append('<div class="ddchart-chart-wrapper ddchart-chart-final"></div>');
				}
				else {
					$(strID).html('<div class="ddchart-y-axis-wrapper"></div><div class="ddchart-x-axis-wrapper" ><div class="ddchart-x-axis-wrapper-sub" ></div><div class="'+objSettings.xWrapperClass+' ddchart-x-axis-label"><div style="display:inline" ></div></div></div><div class="ddchart-chart-wrapper ddchart-chart-final"></div>');
				}
			}
			intYMax = buildYAxis (objSettings, strID);
			buildXAxis (objSettings, strID);
			buildBreadCrumbs (objSettings, strID);
			buildChart (objSettings, strID, intYMax);
		}

		settings = jQuery.extend({
			 margin: 1,
			 chartData: {},
			 chartDataLink: "",
			 action: "init",
			 xOddClass: "",
			 xEvenClass: "",
			 yOddClass: "",
			 yEvenClass: "",
			 xWrapperClass: "",
			 chartWrapperClass: "",
			 chartBarClass: "",
			 chartBarHoverClass:"",
			 chartContext: "",
			 animationDelay: 3000,
			 drillLabel: "",
			 callBeforeLoad: null,
			 callAfterLoad: null
		}, options);
		
		settings.tooltipSettings = jQuery.extend({
			track: true,
			delay: 0,
			showURL: false,
			showBody: " ^ ",
			extraClass: "",
			fixPNG: false,
			left: -70
		}, options.tooltipSettings);

		$(this).data('ddSettings',settings);		
		
		if (settings.callBeforeLoad) settings.callBeforeLoad();		
		if (settings.chartDataLink != "") {
				eval("$.getJSON(settings.chartDataLink, function(data) {objChartSettings = $('#"+$(this).attr("id")+"').data('ddSettings'); objChartSettings.chartData = data; objChartSettings.chartDataLink = ''; $('#"+$(this).attr("id")+"').ddBarChart(objChartSettings);});");
		}
		else {
			setupChart (settings, ('#'+$(this).attr("id")));
			if (settings.callAfterLoad) settings.callAfterLoad();
		}
	};