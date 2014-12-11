$(function () {
  var colors = [
    '#FF3D4C',
    '#A6A497',
    '#00968F',
    '#FEAA3A',
    '#CF2257',
    '#80DDBE',
    '#FBE100',
    '#FF8D8D',
    '#3498DB',
    '#01718D',
    '#8ACCE8',
    '#FF5600',
    '#CFC291',
    '#716C71',
    '#068A5F',
    '#404040',
    '#6BBD2E',
    '#cccccc',
    '#AFE2D3',
    '#834A7D'
  ]

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

  var baseConfig = {
    colors: colors,
    legend: {
      layout: 'horizontal',
      align: 'center',
      verticalAlign: 'bottom',
      itemStyle: {
        padding: '8px'
      }
    },
    tooltip: {
      valuePrefix: '$',
      backgroundColor: '#fff',
      borderColor: '#ccc',
      shadow: false,
      style: {
        padding: '8px'
      }
    },
    credits: {
      enabled: false
    }
  };

  var pieConfig = $.extend({}, baseConfig, {
    chart: {
      type: 'pie'
    },
    plotOptions: {
      pie: {
        animation: false
      }
    }
  });

  var areaConfig = $.extend({}, baseConfig, {
    chart: {
      type: 'areaspline',
      zoomType: 'xy',
      animation: {
        duration: 250,
        easing: 'swing'
      }
    },
    xAxis: {
      categories: window.graphData.months
    },
    yAxis: {
      floor: 0,
      labels: {
        formatter: function () {
          return '$' + this.value;
        }
      }
    },
    plotOptions: {
      areaspline: {
        animation: false,
        stacking: 'normal',
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
      text: 'Monthly Expenses'
    },
    series: formatAreaData(window.graphData.monthly)
  }));

  $('#cumulative-expenses').highcharts($.extend({}, areaConfig, {
    title: {
      text: 'Cumulative Monthly Expenses'
    },
    series: formatAreaData(window.graphData.cumulativeMonthly)
  }));

  $('#total-expenses').highcharts($.extend({}, pieConfig, {
    title: {
      text: 'Total Expenses'
    },
    series: [{
      data: formatPieData(window.graphData.total)
    }]
  }));
});
