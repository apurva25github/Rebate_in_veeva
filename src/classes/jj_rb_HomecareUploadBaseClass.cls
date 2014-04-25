/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  15/04/2014
     @description  Abstract base class of the Homecare upload page 
 
     Function: Handles the controller logic for the Homecare upload page.
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    15/04/2014      Original Version
 */
public abstract class jj_rb_HomecareUploadBaseClass {

 public String convertToString(Blob b)
   {
        String b64;
        String strUrlUTF8;
        String strOriginal;
        
        b64 = EncodingUtil.base64Encode(b);
        //system.debug('String b64: [' + b64 + ']');
        
        strUrlUTF8 = EncodingUtil.urlEncode( b64 , 'UTF-8');
        
        b = EncodingUtil.base64Decode(strUrlUTF8 );
        //system.debug('Blob b: [' + b.toString() + ']');       
        
        try {
           return EncodingUtil.urlDecode( b.toString(), 'UTF-8');        
        }
        catch(Exception ex)
        {}
        return b.toString();   
   }
  
   public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
    List<List<String>> allFields = new List<List<String>>();

    // replace instances where a double quote begins a field containing a comma
    // in this case you get a double quote followed by a doubled double quote
    // do this for beginning and end of a field
    contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
    // now replace all remaining double quotes - we do this so that we can reconstruct
    // fields with commas inside assuming they begin and end with a double quote
    contents = contents.replaceAll('""','DBLQT');
    // we are not attempting to handle fields with a newline inside of them
    // so, split on newline to get the spreadsheet rows
    List<String> lines = new List<String>();
    try {
        lines = contents.split('\n');
    } catch (System.ListException e) {
        System.debug('Limits exceeded?' + e.getMessage());
    }
    Integer num = 0;
    for(String line : lines) {
        // check for blank CSV lines (only commas)
        if (line.replaceAll(',','').trim().length() == 0) break;
        
        List<String> fields = line.split(',');  
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;
        for(String field : fields) {
            if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            }
        }
        
        allFields.add(cleanFields);
    }
    if (skipHeaders) allFields.remove(0);
    return allFields;       
}



public class InvoiceWrapper {
    public List<String> csvHeader;
    public List<InvoiceData> errorRecords;
    public Map<String, List<InvoiceData>> mapInvoiceData;
    public List<InvoiceData> allRecords;
    public InvoiceWrapper() {
        errorRecords = new List<InvoiceData>();
        allRecords = new List<InvoiceData>();
        mapInvoiceData = new Map<String, List<InvoiceData>> ();   
    }
}

public class InvoiceData {
    public String sapCustomerNo;
    public String month;
    public String year;
    public String hospitalId;
    public String hospitalName;
    public String productEANCode;
    public String productName;
    public Integer qty;
    public Decimal unitListPrice;
    public Decimal unitContractPrice;
    public Decimal unitRebate;
    public Decimal netRebate;
    public Decimal vatAmount;
    public String vatCode;
    public Decimal grossRebate;
    public String errorMsg;
}
}