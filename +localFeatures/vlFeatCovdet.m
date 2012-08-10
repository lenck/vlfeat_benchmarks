% VLFEATCOVDET class to wrap around the VLFeat Frame det implementation
%
%   This class wraps aronud VLFeat covariant image frames detector
%
%   The options to the constructor are the same as that for vl_hessian
%   See help vl_hessian to see those options and their default values.
%
%   See also: vl_covdet


classdef vlFeatCovdet < localFeatures.genericLocalFeatureExtractor
  properties (SetAccess=public, GetAccess=public)
    % See help vl_mser for setting parameters for vl_mser
    vl_covdet_arguments
    binPath
  end

  methods
    % The constructor is used to set the options for vl_mser call
    % See help vl_mser for possible parameters
    % The varargin is passed directly to vl_mser
    function obj = vlFeatCovdet(varargin)
      obj.detectorName = 'vlFeat Covdet';
      obj.vl_covdet_arguments = varargin;
      obj.binPath = {which('vl_covdet') which('libvl.so')};
    end

    function [frames descriptors] = extractFeatures(obj, imagePath)
      img = imread(imagePath);
      if(size(img,3)>1), img = rgb2gray(img); end
      img = single(img); % If not already in uint8, then convert

      [path] = fileparts(obj.binPath{1}) ;
      addpath(path);
      clear mex;
      try
        if nargout == 2
          [frames descriptors] = vl_covdet(img,obj.vl_covdet_arguments{:});
        elseif nargout == 1
          [frames] = vl_covdet(img,obj.vl_covdet_arguments{:});
        end
      catch err
        rmpath(path);
        rethrow(err);
      end
      rmpath(path);
      vl_setup;
       
    end
    
    function sign = signature(obj)
      sign = [commonFns.file_signature(obj.binPath{:}) ';'...
              evalc('disp(obj.vl_covdet_arguments)')];
    end

  end
end
