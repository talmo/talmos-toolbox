% Return probabilty of data given model
function prob = gmm_eval(data, model)
   [N D] = size(data);
   K = length(model.pn);
   prob = 0;
   for k = 1:K
      s = model.sigma(:,:,K);
      X = data - repmat(model.mu(k,:),[N 1]);
      prob = prob + model.pn(k)./sqrt(det(s)).*exp(-0.5.*sum((X*inv(s)).*X,2));
   end
   prob = prob.*(2.*pi).^(-D/2);
end
