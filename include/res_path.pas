unit res_path;

interface

uses

  System.SysUtils;

function getResourcePath(const subDir: string = ''): string;

implementation

uses
  System.IOUtils;

function getResourcePath(const subDir: string = ''): string;
{$WRITEABLECONST ON}
const
  baseRes: string = '';
{$WRITEABLECONST OFF}
var
  basePath: PChar;
begin
  if (baseRes.IsEmpty) then
  begin
    baseRes := TPath.GetLibraryPath;
    // We replace the last bin/ with res/ to get the the resource path
    baseRes := TPath.Combine(baseRes, '..');
    baseRes := TPath.Combine(baseRes, '..');
    baseRes := TPath.Combine(baseRes, 'res');
  end;
  Result := TPath.Combine(baseRes, subDir);
end;

end.
