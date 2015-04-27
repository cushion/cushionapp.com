$(function () {
  function currencyToFloat(column) {
    return parseFloat(column.replace('$', ''));
  }

  function formatAreaData(data) {
    return $.map(data, function(row, i) {
      var service = row[0];
      var provider = row[1];

      return {
        name: service,
        data: $.map(row.slice(2), function(column) { return currencyToFloat(column) })
      }
    });
  }

  function formatPieData(data) {
    return $.map(data, function(row) { return [[row[0], currencyToFloat(row[1])]] });
  }

  var plotLines = $.map(window.graphData.markers, function (line) {
    return {
        label: {
          x: 10,
          y: 20,
          rotation: 0,
          text: line[0]
        },
        color: '#4099FF',
        width: 2,
        zIndex: 1,
        value: window.graphData.months.indexOf(line[1])
      };
  });

  var colors = $.map(window.graphData.monthly, function (row) {
    return window.graphData.colors[row[0]]
  });

  var baseConfig = {
    colors: colors,
    legend: {
      enabled: false
    },
    tooltip: {
      valuePrefix: '$',
      backgroundColor: '#fff',
      borderColor: '#ccc',
      shadow: false,
      style: {
        padding: '8px'
      },
      formatter: function () {
        return '<strong>' + this.series.name + '</strong><br>' + this.x + '<br>$' + this.y.toFixed(2);
      }
    },
    credits: {
      enabled: false
    }
  };

  var areaConfig = $.extend({}, baseConfig, {
    chart: {
      type: 'areaspline',
      spacing: [10, 0, 0, 0],
      animation: {
        duration: 250,
        easing: 'swing'
      }
    },
    xAxis: {
      categories: window.graphData.months,
      tickmarkPlacement: 'on',
      staggerLines: 1,
      plotLines: plotLines
    },
    yAxis: {
      gridLineColor: '#eeeeee',
      labels: {
        x: -2,
        formatter: function () {
          return '$' + this.value;
        }
      },
      title: {
        enabled: false
      }
    },
    plotOptions: {
      areaspline: {
        animation: false,
        stacking: 'normal',
        lineWidth: 0,
        showEmpty: false,
        states: {
          hover: {
            lineWidthPlus: 4
          }
        },
        marker: {
          enabled: false,
          symbol: 'circle',
          radius: 3,
          states: {
            hover: {
              enabled: true
            }
          }
        }
      }
    }
  });

  $('#monthly-expenses').highcharts($.extend({}, areaConfig, {
    title: {
      text: ''
    },
    series: formatAreaData(window.graphData.monthly)
  }));
});
