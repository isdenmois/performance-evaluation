function secondResult(r) {
	r = JSON.parse(r);
	$('.result.hidden').removeClass('hidden');
	renderChart('w-chart', 'Распределение w', r.w);
	$('#time-mod').html(r.time);
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

	PVIface.computeSecond(k, lambda, TR1_sigma, TR1_mu, TR2, TR3, TR4_sigma, TR4_mu, TR5_sigma, TR5_mu, secondResult);
}

$(window).load(function() {
	$('#second-form').submit(computeSecond);
});
