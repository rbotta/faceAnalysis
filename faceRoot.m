function faceRootPath = faceRoot
%faceRoot: Root of FAT (Face Analysis Toolbox)
%
%	Usage:
%		faceRootPath=faceRoot
%
%	Description:
%		faceRootPath=faceRoot returns a string indicating the installation folder of FAT (Face Analysis Toolbox).
%
%	Example:
%		faceRootPath=faceRoot;
%
%	Category: Utility
%	Mymy, 20130103

faceRootPath=fileparts(which(mfilename));
fprintf('The installation root of FAT is %s\n', faceRootPath);