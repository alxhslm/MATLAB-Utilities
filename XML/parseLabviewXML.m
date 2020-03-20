function LabviewXmlStruct = parseLabviewXML(filepath)
% This function converts XML files which have been created using the
% "Flatten To XML" and "Write to XML File" VIs into structure arrays,
% using the names of controls/variables as field names in the structure.
% It supports reading clusters, arrays, boolean values, timestamps, enums,
% integers, fixed-point numbers, floating point numbers, strings, rings,
% analog waveforms and variant data.
% Clusters and arrays can contain any of the supported types in any
% combination. Error clusters are clusters with three named elements so
% they are supported, too.
%
% All variables need to have names, except array elements. If a variable
% does not have a name the function exits with an error. Variable names
% need to be unique at their level of nesting (i.e. names of elements in a
% cluster must be unique). Variable names are converted to legal structure
% field names (see createLegalStructFieldName function).
% 
% Integers are imported in their correct type, i.e. a control of type
% I8/I16/I32/I64/U8/U16/U32/U64 is imported as int8/int16/int32/int64/
% uint8/uint16/uint32/uint64.
%
% Floating-point numbers are imported as double precision floats if possible.
% This is the case for both real and complex single and double precision
% floating point numbers. Extended precision real and complex
% floating-point numbers are imported as strings because there is no
% numeric equivalent in MATLAB®. Fixed-point numbers are imported as a
% structure which contains word and integer length as doubles, the signed
% flag as logical, value, minimum and maximum as structs containing a
% negative flag as logical and the value as a uint64 (independend of the
% negative flag value). The fixed-point struct contains another struct in
% the field "Delta" which contains word length, integer length and value as
% above. Overflow status is not exported by the "Flatten To XML" VI and
% therefore cannot be imported.
%
% Boolean values are imported as logicals.
%
% Timestamps are converted to datetime structures with TimeZone set to UTC.
% Please note that during this conversion precision is lost because the
% datetime structure cannot resolve the attosecond precision of LabVIEW™
% timestamps.
% 
% Text/menu rings are imported as their representation since the "Flatten
% To XML" VI does not include the Item value in the XML file.
%
% Enums are imported as a string containing the selected item.
%
% LvVariant entries are essentially just containers of other data
% structures, so they are imported as a structure array containing these
% other data structures. Please note that the "Flatten To XML" VI does not
% include variant attributes, so they are not imported.
%
% Clusters are imported as structs containing their elements as fields with
% the element name being the field name.
%
% Arrays are imported as either cell or ordinary array, depending on the
% type of elements the array contains: Single and double precision real and
% complex floating point numbers, all integer types and logicals are
% converted to ordinary arrays. All numbers of dimensions are supported.
% Arrays can contain all other supported data types.
%
% Strings are imported as a character array if the string is a single line
% or as a cell array (column vector) of character arrays if the string has
% multiple lines.
%
% Paths are handled as strings.
%
% Analog waveforms are essentially clusters and are imported as such. They
% contain a timestamp in field "t0", a double precision floating point
% number in the field "dt", an array named "Y", an error cluster in the
% field "error" and an LvVariant named "attributes". All possible data
% types of the "Y" array elements are supported.
%
% Digital waveforms are not supported. Feel free to add this functionality!
%
% For now, the XML file must start with the two lines
%	<?xml version='1.0' standalone='yes' ?>
%	<LVData xmlns="http://www.ni.com/LVData">
% followed by a <Version> tag and end with the line
%	</LVData>
% These lines are created by the "Write to XML File" VI.
%
% Example XML files and VIs are still missing.
%
% This function is MUCH faster than using the xmlread function!
% 
% Version 1.2.0.1
%
% Tested with LabVIEW™ software version 12.0.1f5, 15.0 and
% MATLAB® version R2016a/9.0, R2017b/9.3.
% 
% MATLAB is a registered trademark of The MathWorks, Inc.,
% LabVIEW is a trademark of National Instruments.
%
% Copyright 2019, Tilman Raphael Schröder <tilman.schroeder@uni-due.de>
	[ fileId, errmsg ] = fopen(filepath, 'r');
	assert(fileId > -1, errmsg);
	cleanupObj = onCleanup(@() fclose(fileId));
	assert(strcmp(fgetltrim(fileId), '<?xml version=''1.0'' standalone=''yes'' ?>'));
	assert(strcmp(fgetltrim(fileId), '<LVData xmlns="http://www.ni.com/LVData">'));
	
	Version = convertSpecialChars(parseTag(fgetltrim(fileId), fileId, '<Version>', '</Version>'));
	
	LabviewXmlStruct = addToStruct('Version', Version, struct());
	[ name, value ] = parseBlock(fgetltrim(fileId), fileId);
	
	LabviewXmlStruct = addToStruct(name, value, LabviewXmlStruct);
	assert(strcmp(fgetltrim(fileId), '</LVData>'));
end

function tagValue = parseTag(line, fileId, startTag, endTag)
	assert(strncmp(line, startTag, numel(startTag)));
	line = line((numel(startTag) + 1):end); % remove start tag
	tagValue = cell(0, 1);
	i = 1;
	while ~strncmp(fliplr(line), fliplr(endTag), numel(endTag))
		tagValue{i, 1} = line;
		line = fgetltrim(fileId);
		i = i + 1;
	end
	tagValue{i, 1} = line(1:(numel(line) - numel(endTag)));
	if isscalar(tagValue)
		tagValue = tagValue{1};
	end
end

function val = parseValTag(fileId)
	val = parseTag(fgetltrim(fileId), fileId, '<Val>', '</Val>');
end

function name = parseNameTag(fileId)
	name = convertSpecialChars(parseTag(fgetltrim(fileId), fileId, '<Name>', '</Name>'));
end

function NumElts = parseNumEltsTag(fileId)
	NumElts = str2double(parseTag(fgetltrim(fileId), fileId, '<NumElts>', '</NumElts>'));
end

function [ name, value ] = parseBlock(line, fileId)
	floatTypes = { '<SGL>', '<DBL>', '<CSG>', '<CDB>' };
	integerTypes = { '<I8>', '<I16>', '<I32>', '<I64>', '<U8>', '<U16>', '<U32>', '<U64>' };
	booleanType = { '<Boolean>' };
	cell2matTypes = [ floatTypes, integerTypes, booleanType ];
	% extended floating point (real and complex) vars are imported as
	% strings because there is no Matlab equivalent data type
	stringTypes = { '<String>', '<EXT>', '<CXT>', '<Path>' };
	waveformTypes = {	'<SGLWaveform>', ...
						'<DBLWaveform>', ...
						'<EXTWaveform>', ...
						'<CSGWaveform>', ...
						'<CDBWaveform>', ...
						'<CXTWaveform>', ...
						'<I8Waveform>', ...
						'<I16Waveform>', ...
						'<I32Waveform>', ...
						'<I64Waveform>', ...
						'<U8Waveform>', ...
						'<U16Waveform>', ...
						'<U32Waveform>', ...
						'<U64Waveform>'};
	enumTypes = { '<EW>', '<EL>' };
	switch line
		case '<Cluster>'
			[ name, value ] = parseClusterBlock(fileId);
		case floatTypes
			[ name, value ] = parseFloatBlock(fileId, line);
		case '<FXP>'
			[ name, value ] = parseFixedBlock(fileId);
		case booleanType
			[ name, value ] = parseBooleanBlock(fileId);
		case integerTypes
			[ name, value ] = parseIntegerBlock(fileId, line);
		case stringTypes
			[ name, value ] = parseStringBlock(fileId, line);
		case '<Array>'
			[ name, value ] = parseArrayBlock(fileId, cell2matTypes);
		case waveformTypes
			[ name, value ] = parseWaveformBlock(fileId, line);
		case '<Timestamp>'
			[ name, value ] = parseTimestampBlock(fileId);
		case '<LvVariant>'
			[ name, value ] = parseLvVariantBlock(fileId);
		case enumTypes
			[ name, value ] = parseEnumBlock(fileId, line);
		otherwise
			error(['Unknown tag ''', line, '''!']);
	end
end

function [ name, value ] = parseClusterBlock(fileId)
	name = parseNameTag(fileId);
	NumElts = parseNumEltsTag(fileId);
	value = struct();
	line = fgetltrim(fileId);
	i = 0;
	while ~strcmp(line, '</Cluster>')
		i = i + 1;
		[ thisElementName, thisElementValue ] = parseBlock(line, fileId);
		value = addToStruct(thisElementName, thisElementValue, value);
		line = fgetltrim(fileId);
	end
	assert(i == NumElts);
end

function [ name, value ] = parseFloatBlock(fileId, type)
	name = parseNameTag(fileId);
	value = str2double(parseValTag(fileId));
	assert(strcmp(fgetltrim(fileId), [ '</', type(2:end) ]));
end

function [ name, value ] = parseFixedBlock(fileId)
	name = parseNameTag(fileId);
	% word length is between 1 and 64 bit.
	wordLength = str2double(parseTag(fgetltrim(fileId), fileId, '<WordLength>', '</WordLength>'));
	% integer length is between -1024 and +1024 bit.
	integerLength = str2double(parseTag(fgetltrim(fileId), fileId, '<IntegerLength>', '</IntegerLength>'));
	if strcmp(parseTag(fgetltrim(fileId), fileId, '<Sign>', '</Sign>'), 'Signed')
		signed = true;
	else
		signed = false;
	end
	val = hex2decStruct(parseValTag(fileId));
	minimum = hex2decStruct(parseTag(fgetltrim(fileId), fileId, '<Minimum>', '</Minimum>'));
	maximum = hex2decStruct(parseTag(fgetltrim(fileId), fileId, '<Maximum>', '</Maximum>'));
	assert(strcmp(fgetltrim(fileId), '<Delta>'));
	deltaWordLength = str2double(parseTag(fgetltrim(fileId), fileId, '<WordLength>', '</WordLength>'));
	deltaIntegerLength = str2double(parseTag(fgetltrim(fileId), fileId, '<IntegerLength>', '</IntegerLength>'));
	deltaVal = hex2decStruct(parseValTag(fileId));
	assert(strcmp(fgetltrim(fileId), '</Delta>'));
	assert(strcmp(fgetltrim(fileId), '</FXP>'));
	delta = struct('WordLength', deltaWordLength, 'IntegerLength', deltaIntegerLength, 'Val', deltaVal);
	value = struct(	'WordLength', wordLength, ...
					'IntegerLength', integerLength, ...
					'Sign', signed, ...
					'Val', val, ...
					'Minimum', minimum, ...
					'Maximum', maximum, ...
					'Delta', delta);
end

function [ name, value ] = parseBooleanBlock(fileId)
	name = parseNameTag(fileId);
	value = logical(str2double(parseValTag(fileId)));
	assert(strcmp(fgetltrim(fileId), '</Boolean>'));
end

function [ name, value ] = parseIntegerBlock(fileId, type)
	name = parseNameTag(fileId);
	tagValue = parseValTag(fileId);
	if strcmp(type(2), 'U')
		conversionFunc = 'uint';
	else
		conversionFunc = 'int';
	end
	conversionFunc = [ conversionFunc, type(3:(end - 1)) ];
	value = str2num([ conversionFunc, '(', tagValue, ')' ]); %#ok<ST2NM>
	assert(strcmp(fgetltrim(fileId), [ '</', type(2:end) ]));
end

function [ name, value ] = parseStringBlock(fileId, type)
	name = parseNameTag(fileId);
	value = convertSpecialChars(parseValTag(fileId));
	assert(strcmp(fgetltrim(fileId), [ '</', type(2:end) ]));
end

function [ name, value ] = parseArrayBlock(fileId, cell2matTypes)
	name = parseNameTag(fileId);
	dimsizeStart = '<Dimsize>';
	dimsizeEnd   = '</Dimsize>';
	line = fgetltrim(fileId);
	arraySize = [ 1, 1 ];
	numDimsizeTags = 0;
	while strncmp(dimsizeStart, line, numel(dimsizeStart))
		numDimsizeTags = numDimsizeTags + 1;
		arraySize(numDimsizeTags) = str2double(parseTag(line, fileId, dimsizeStart, dimsizeEnd));
		line = fgetltrim(fileId);
	end
	assert(numDimsizeTags > 0);
	numelArray = prod(arraySize(:));
	type = line;
	value = cell(arraySize);
	if numelArray > 0
		i = 0;
		while ~strcmp(line, '</Array>')
			i = i + 1;
			assert(strcmp(type, line));
			% in arrays, names are ignored
			[ ~, thisElementValue ] = parseBlock(line, fileId);
			value{i} = thisElementValue;
			line = fgetltrim(fileId);
		end
		assert(i == numelArray);
	else % empty array
		% in empty arrays, there is one block with empty Name and empty Val
		% tag
		parseBlock(line, fileId);
		assert(strcmp(fgetltrim(fileId), '</Array>'));
	end
	
	if any(strcmp(type, cell2matTypes))
		value = cell2mat(value);
	end
end

function [ name, value ] = parseWaveformBlock(fileId, type)
	name = parseNameTag(fileId);
	assert(strcmp('<Cluster>', fgetltrim(fileId)));
	[ ~, value ] = parseClusterBlock(fileId);
	assert(strcmp(fgetltrim(fileId), [ '</', type(2:end) ]));
end

function [ name, value ] = parseTimestampBlock(fileId)
	name = parseNameTag(fileId);
	assert(strcmp('<Cluster>', fgetltrim(fileId)));
	parseNameTag(fileId); % name of cluster is empty, so we cannot use parseClusterBlock(fileId)
	NumElts = parseNumEltsTag(fileId);
	assert(4 == NumElts);
	I32data = zeros(1, NumElts, 'int32');
	for i = 1:NumElts
		line = fgetltrim(fileId);
		assert(strcmp('<I32>', line));
		[ ~, I32data(i) ] = parseIntegerBlock(fileId, line);
	end

	U32data = typecast(I32data, 'uint32');
	
	LabviewEpoch = datetime(1904, 1, 1, 0, 0, 0, 0, 'TimeZone', 'UTC');
	secondsAfterLabviewEpoch = typecast([U32data(3), U32data(4)], 'int64');
	milliseconds = typecast([U32data(1), U32data(2)], 'uint64') * (2^(-64) * 1000);
	
	value = LabviewEpoch + duration(0, 0, secondsAfterLabviewEpoch, milliseconds);
	
	assert(strcmp('</Cluster>', fgetltrim(fileId)));
	assert(strcmp('</Timestamp>', fgetltrim(fileId)));
end

function [ LvVariantName, LvVariantValue ] = parseLvVariantBlock(fileId)
	LvVariantName = parseNameTag(fileId);
	LvVariantValue = struct();
	line = fgetltrim(fileId);
	while ~strcmp('</LvVariant>', line)
		[ name, value ] = parseBlock(line, fileId);
		LvVariantValue = addToStruct(name, value, LvVariantValue);
		line = fgetltrim(fileId);
	end
end

function [ name, value ] = parseEnumBlock(fileId, type)
	name = parseNameTag(fileId);
	choiceStart = '<Choice>';
	choiceEnd   = '</Choice>';
	line = fgetltrim(fileId);
	choices = cell(0);
	i = 0;
	while strncmp(choiceStart, line, numel(choiceStart))
		i = i + 1;
		choices{i} = parseTag(line, fileId, choiceStart, choiceEnd);
		line = fgetltrim(fileId);
	end
	assert(i > 0);
	value = convertSpecialChars(choices{str2double(parseTag(line, fileId, '<Val>', '</Val>')) + 1});
	assert(strcmp(fgetltrim(fileId), [ '</', type(2:end) ]));
end

function LabviewXmlStruct = addToStruct(name, value, LabviewXmlStruct)
	assert(~isfield(LabviewXmlStruct, name));
	LabviewXmlStruct.(createLegalStructFieldName(name)) = value;
end

function name = createLegalStructFieldName(name)
	name = replace(name, ' ', '_');
	name = replace(name, '[', '_');
	name = replace(name, ']', '_');
	name = replace(name, '@', '_at_');
	name = replace(name, '-', '_dash_');
	name = replace(name, 'ä', 'ae');
	name = replace(name, 'ö', 'oe');
	name = replace(name, 'ü', 'ue');
	name = regexprep(name, '\W', '_');
	name = regexprep(name, '^[^a-zA-Z]', 'a');
	name = matlab.lang.makeValidName(name, 'ReplacementStyle', 'hex');
end

function str = convertSpecialChars(str)
	str = replace(str,  '&lt;', '<');
	str = replace(str,  '&gt;', '>');
	str = replace(str, '&amp;', '&');
end

function decStruct = hex2decStruct(h)
	assert(ischar(h));
	assert(size(h, 1) == 1);
	h = lower(h);
	if strncmp(h, '-', 1)
		negative = true;
		h = h(2:end);
	else
		negative = false;
	end
	assert(strncmp(h, '0x', 2));
	h = h(3:end); % remove 0x
	% remove leading zeros
	[token, remain] = strtok(h, '0');
	h = [ token, remain ];

	dec = uint64(0);
	if ~isempty(h)
		length = size(h, 2);
		assert(all((h >= '0' & h <= '9') | (h >= 'a' & h <= 'f')));

		numberIndices = h <= 64; % Numbers
		h(numberIndices) = h(numberIndices) - 48;

		letterIndices =  h > 64; % Letters
		h(letterIndices) = h(letterIndices) - 97 + 10;
		
		h = cast(h, 'uint64');
		p = uint64(16).^uint64((length - 1):-1:0);
		dec = sum(h.*p , 'native');
	end
	decStruct = struct('uint64', dec, 'negative', negative);
end

function line = fgetltrim(fid)
line = strtrim(fgetl(fid));
end