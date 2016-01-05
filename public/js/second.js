function secondResult(r) {
	r = JSON.parse(r);
	$('.result.hidden').removeClass('hidden');
	renderChart('w-chart', 'Распределение суммы периодов ожидания', 'Время ожидания', r.w);
	$('#time-mod').html(r.time);
	if(r.load && r.load.length == 5) {
		$('#load-1').html(r.load[0]);
		$('#load-2').html(r.load[1]);
		$('#load-3').html(r.load[2]);
		$('#load-4').html(r.load[3]);
		$('#load-5').html(r.load[4]);
	}
	$('#avg-time').html(r.avgTime);
	$('#avg-calc').html(r.avgCalc);
	$('#avg-w').html(r.avgW);
}

function computeSecond(e) {
	e.preventDefault();

	var k = $('#k-value', this).val();
	var lambda = $('#lambda', this).val();
	var TR1_sigma = $('#sigma-1').val();
	var TR1_mu = $('#mu-1').val();
	var TR2 = $('#sigma-2').val();
	var TR3 = $('#teta-3').val();
	var TR4_sigma = $('#sigma-4').val();
	var TR4_mu = $('#mu-4').val();
	var TR5_sigma = $('#sigma-5').val();
	var TR5_mu = $('#mu-5').val();

	PVIface.computeSecond(k, lambda, TR1_mu, TR1_sigma, TR2, TR3, TR4_mu, TR4_sigma, TR5_mu, TR5_sigma, secondResult);
}

$(window).load(function() {
	$('#second-form').submit(computeSecond);
});
