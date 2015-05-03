$(function () {
  function unformatCurrency(num) {
    return parseFloat(num.replace('$', ''));
  }

  function numberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  function formatCurrency(num) {
    return '$' + numberWithCommas(num.toFixed(2));
  }

  function formatAreaData(data) {
    return $.map(data, function(row, i) {
      var service = row[0];
      var provider = row[1];
      var color = row[2];

      return {
        name: service,
        data: $.map(row.slice(3), function(column) { return unformatCurrency(column) })
      }
    });
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

  var baseConfig = {
    colors: $.map(window.graphData.monthly_cost, function (row) {
      return row[2];
    }),
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

  expenses_sum = 0;
  $('.js-expense__total-cost').each(function (n) {
    var cost = unformatCurrency(window.graphData.total_cost[n][1]);

    $(this).text(formatCurrency(cost));
    expenses_sum += cost;
  });

  $('.js-expenses__total-cost').text(formatCurrency(expenses_sum));

  $('#monthly-expenses').highcharts($.extend({}, areaConfig, {
    title: {
      text: ''
    },
    series: formatAreaData(window.graphData.monthly_cost)
  }));
});
