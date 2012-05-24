# Images Importer

Imports images from the folder and store them into the taken date named subfolders.

## Examples

To import all images recursively from the current folder to the .\Imported subfolder just call:

	imimg

or

	Import-Images

If source or destintion paths re different from the defaults, few params are also availble to setup:

	Import-Images -SourceDir:"C:\Camera" -DestinationDir:"C:\MyPics"

Images are removing from the sources folder by defult. In case if you want to keem them, use special param:

	Import-Images -DontRemoveFilesAfterImport

## Credits

 * http://blogs.technet.com/b/jamesone/archive/2007/07/13/exploring-photographic-exif-data-using-powershell-of-course.aspx
 * http://pastebin.com/w0Hn5LCv

## Licence

Feel free to do everything you want