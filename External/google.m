function google(varargin)
url = ['https://www.google.co.uk/search?q=',strjoin(varargin,'+')];
chrome(url)