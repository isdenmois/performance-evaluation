function renderChart(selector, title, points) {
    var chart = new CanvasJS.Chart(selector, {
      title: {
        text: title
      },
      data: [
        {
          color: "#009688",
          type: points.length < 150 ? "column" : "line",
          dataPoints: points
        }
      ],
      axisY: {
        title: 'Вероятность'
      },
      axisX: {
        title: '?'
      }
    });

    chart.render()
}
