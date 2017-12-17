using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WIA;
using Newtonsoft.Json;

namespace CallScanFunction
{
    class Program
    {

        static void Main(string[] args)
        {
            string savePath = @"d:\";
            string scannerId = "";
            string sampleFile = "";

            if (args.Length >= 1)
            {

                switch (args[0])
                {
                    case "getDevices":
                        Console.Write(JsonConvert.SerializeObject(getDevices()));
                        break;
                    case "callScan":
                        if (args.Length >=3)
                        {
                            scannerId = args[1];
                            savePath = args[2];
                            Scan(scannerId, savePath, false, "");
                        } else
                        {
                            Console.Error.Write("Bad command.");
                        }
                        break;
                    case "autoScan":
                        if (args.Length >= 2)
                        {
                            savePath = args[1];
                            if (getDevices().Count >0)
                            {
                                Scan(getDevices()[0], savePath, false, "");
                            } else
                            {
                                Console.Error.Write("Not found any scanner device.");
                            }
                            
                        }
                        else
                        {
                            Console.Error.Write("Bad command.");
                        }
                        break;
                    case "bypass":
                        if (args.Length >= 3)
                        {
                            savePath = args[1];
                            sampleFile = args[2];
                            Scan("", savePath, true, sampleFile);
                        } else
                        {
                            Console.Error.Write("Bad command.");
                        }
                        break;
                    default:
                        Console.Error.Write("Bad command.");
                        break;
                }

            } else
            {
                Console.Error.Write("Bad command.");
            }

            
        }

        private static void Scan(string scannerId,string savePath, bool isTesting, string sampleFile)
        {
            string fileName = Path.Combine(savePath, DateTime.Now.ToString("dd-MM-yyyy-hh-mm-ss-fffffff") + ".png");

            if (isTesting)
            {
                File.Copy(sampleFile, fileName);
                Console.Write(fileName);
            }
            else
            {
                try
                {

                    // get devices
                    Device device = null;
                    DeviceManager manager = new DeviceManager();

                    foreach (DeviceInfo info in manager.DeviceInfos)
                    {
                        if (info.DeviceID == scannerId)
                        {
                            device = info.Connect();
                            break;
                        }
                    }

                    if (device == null)
                    {
                        string availableDevices = "";
                        foreach (WIA.DeviceInfo info in manager.DeviceInfos)
                        {
                            availableDevices += info.DeviceID + "\n";
                        }

                        Console.Error.Write("The device with provided ID could not be found. Available Devices:\n" + availableDevices);
                    }
                    

                    /*CommonDialogClass commonDialogClass = new CommonDialogClass();
                    Device scannerDevice = commonDialogClass.ShowSelectDevice(WiaDeviceType.ScannerDeviceType, true, false);*/
                    if (device != null)
                    {
                        Item scannnerItem = device.Items[1];
                        //AdjustScannerSettings(scannnerItem, 300, 0, 0, 1010, 620, 0, 0);
                        //object scanResult = commonDialogClass.ShowTransfer(scannnerItem, WIA.FormatID.wiaFormatPNG, false);
                        object scanResult = scannnerItem.Transfer(WIA.FormatID.wiaFormatPNG);

                        if (scanResult != null)
                        {
                            ImageFile image = (ImageFile)scanResult;
                            SaveImageToPNGFile(image, fileName);
                            Console.Write(fileName);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.Error.Write(ex.Message);
                    //Console.WriteLine(savePath + DateTime.Now.ToString("dd-MM-yyyy-hh-mm-ss-fffffff") + ".png");
                    //Console.ReadKey();
                }
            }
        }

        private static void AdjustScannerSettings(IItem scannnerItem, int scanResolutionDPI, int scanStartLeftPixel, int scanStartTopPixel,
            int scanWidthPixels, int scanHeightPixels, int brightnessPercents, int contrastPercents)
        {
            const string WIA_HORIZONTAL_SCAN_RESOLUTION_DPI = "6147";
            const string WIA_VERTICAL_SCAN_RESOLUTION_DPI = "6148";
            const string WIA_HORIZONTAL_SCAN_START_PIXEL = "6149";
            const string WIA_VERTICAL_SCAN_START_PIXEL = "6150";
            const string WIA_HORIZONTAL_SCAN_SIZE_PIXELS = "6151";
            const string WIA_VERTICAL_SCAN_SIZE_PIXELS = "6152";
            const string WIA_SCAN_BRIGHTNESS_PERCENTS = "6154";
            const string WIA_SCAN_CONTRAST_PERCENTS = "6155";
            SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_RESOLUTION_DPI, scanResolutionDPI);
            SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_RESOLUTION_DPI, scanResolutionDPI);
            SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_START_PIXEL, scanStartLeftPixel);
            SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_START_PIXEL, scanStartTopPixel);
            SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_SIZE_PIXELS, scanWidthPixels);
            SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_SIZE_PIXELS, scanHeightPixels);
            SetWIAProperty(scannnerItem.Properties, WIA_SCAN_BRIGHTNESS_PERCENTS, brightnessPercents);
            SetWIAProperty(scannnerItem.Properties, WIA_SCAN_CONTRAST_PERCENTS, contrastPercents);
        }

        private static void SetWIAProperty(IProperties properties, object propName, object propValue)
        {
            Property prop = properties.get_Item(ref propName);
            prop.set_Value(ref propValue);
        }

        private static void SaveImageToPNGFile(ImageFile image, string fileName)
        {
            ImageProcess imgProcess = new ImageProcess();
            object convertFilter = "Convert";
            string convertFilterID = imgProcess.FilterInfos.get_Item(ref convertFilter).FilterID;
            imgProcess.Filters.Add(convertFilterID, 0);
            SetWIAProperty(imgProcess.Filters[imgProcess.Filters.Count].Properties, "FormatID", WIA.FormatID.wiaFormatPNG);
            image = imgProcess.Apply(image);
            image.SaveFile(fileName);
        }

        private static List<string> getDevices()
        {
            List<string> devices = new List<string>();
            WIA.DeviceManager manager = new WIA.DeviceManager();

            foreach (WIA.DeviceInfo info in manager.DeviceInfos)
            {
                devices.Add(info.DeviceID);
            }

            return devices;
        }
    }
}
