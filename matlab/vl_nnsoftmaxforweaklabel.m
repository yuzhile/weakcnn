function Y = vl_nnsoftmaxforweaklabel(X,c,dzdy)
% VL_NNSOFTMAXLOSS  CNN combined softmax and logistic loss
%    Y = VL_NNSOFTMAX(X, C) applies the softmax operator followed by
%    the logistic loss the data X. X has dimension H x W x D x N,
%    packing N arrays of W x H D-dimensional vectors.
%
%    C contains the class labels, which should be integers in the range
%    1 to D. C can be an array with either N elements or with dimensions
%    H x W x 1 x N dimensions. In the fist case, a given class label is
%    applied at all spatial locations; in the second case, different
%    class labels can be specified for different locations.
%
%    DZDX = VL_NNSOFTMAXLOSS(X, C, DZDY) computes the derivative DZDX of the
%    function projected on the output derivative DZDY.
%    DZDX has the same dimension as X.
% Copyright (C) 2014-15 Andrea Vedaldi.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

%X = X + 1e-6 ;

%indicating absence -1 presence =+1
y=[-1,1];
y=single(y);
szLabel=size(c);
classNum=szLabel(1);
trainSize=szLabel(2);
Y=0;
if nargin<=2
    for i=1:trainSize
        for j=1:classNum
            if c(j,i)==1
                Y=Y+log(1+exp(-y(2)*X(1,1,j,i)));
            elseif c(j,i)==0
                Y=Y+log(1+exp(-y(1)*X(1,1,j,i)));
            end
        end
        Y=0;
    end
else
    Y=zeros(size(X));
    for i=1:trainSize
        for j=1:classNum
            if c(j,i)==1
                Y(1,1,j,i)=(-y(2)*exp(-y(2)*X(1,1,j,i)))/(1+exp(-y(2)*X(1,1,j,i)));
            elseif c(j,i)==0
                Y(1,1,j,i)=(-y(1)*exp(-y(1)*X(1,1,j,i)))/(1+exp(-y(1)*X(1,1,j,i)));
            end
        end
    end
end


% X=sum(X,1);
% X=sum(X,2);
% 
% sz = [size(X,1) size(X,2) size(X,3) size(X,4)] ;
% 
% if numel(c) == sz(4)
%   % one label per image
%   c = reshape(c, [1 1 1 sz(4)]) ;
% end
% if size(c,1) == 1 & size(c,2) == 1
%   c = repmat(c, [sz(1) sz(2)]) ;
% end
% 
% % one label per spatial location
% sz_ = [size(c,1) size(c,2) size(c,3) size(c,4)] ;
% assert(isequal(sz_, [sz(1) sz(2) sz_(3) sz(4)])) ;
% assert(sz_(3)==1 | sz_(3)==2) ;
% 
% % class c = 0 skips a spatial location
% mass = single(c(:,:,1,:) > 0) ;
% if sz_(3) == 2
%   % the second channel of c (if present) is used as weights
%   mass = mass .* c(:,:,2,:) ;
%   c(:,:,2,:) = [] ;
% end
% 
% % convert to indexes
% c = c - 1 ;
% c_ = 0:numel(c)-1 ;
% c_ = 1 + ...
%   mod(c_, sz(1)*sz(2)) + ...
%   (sz(1)*sz(2)) * max(c(:), 0)' + ...
%   (sz(1)*sz(2)*sz(3)) * floor(c_/(sz(1)*sz(2))) ;
% 
% % compute softmaxloss
% Xmax = max(X,[],3) ;
% ex = exp(bsxfun(@minus, X, Xmax)) ;
% 
% %n = sz(1)*sz(2) ;
% if nargin <= 2
%   t = Xmax + log(sum(ex,3)) - reshape(X(c_), [sz(1:2) 1 sz(4)]) ;
%   Y = sum(sum(sum(mass .* t,1),2),4) ;
% else
%   Y = bsxfun(@rdivide, ex, sum(ex,3)) ;
%   Y(c_) = Y(c_) - 1;
%   Y = bsxfun(@times, Y, bsxfun(@times, mass, dzdy)) ;
% end
