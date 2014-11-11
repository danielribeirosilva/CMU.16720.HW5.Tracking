function model = learnLS(F, D)
	%model = F \ D;
	ATA1AT = (F' * F + eye(size(F, 2))) \ F';
	model = ATA1AT * D;
end
