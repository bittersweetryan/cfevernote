package com.sudios714.cfevernote;

/**
 *
 * @author Ryan Anknlam
 * 
 * Copyright (c) 2011 Ryan Anklam
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

//import evernote objects
import com.evernote.edam.notestore.*;
import com.evernote.edam.userstore.*;
import com.evernote.edam.error.*;
import com.evernote.edam.userstore.Constants;
import com.evernote.edam.type.*;

//imprt thrift
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.transport.THttpClient;
import org.apache.thrift.transport.TTransportException;

public class CFEvernote {
    
    private String apiKey;
    private String apiAccount;
    
    private String hostName;
    private String userStoreURL;
    private String noteStoreURLBase;
    private String userAgent;
    private String authToken;
    
    private String userStoreQueryParam = "/edam/user";
    private String noteStoreBaseQueryParam = "/edam/note/";
    
    private static final String MAJOR = "0";
    private static final String MINOR = "1";
    
    private UserStore.Client userStore;
    private NoteStore.Client noteStore;
    
    /**
     * Default Constructer
     */
    public CFEvernote(){
        this.apiAccount = "";
        this.apiKey = "";
        this.hostName = "";
    }
    
    /**
     * 
     * @param apiKey
     * @param apiAccount
     * @param apiSecret
     * @param hostName 
     */
    public CFEvernote(String apiAccount, String apiKey, String hostName){
        
        this.apiAccount = apiAccount;
        this.apiKey = apiKey;
        this.hostName = hostName;
        
        this.userStoreURL = "https://".concat(hostName).concat(this.userStoreQueryParam);
        this.noteStoreURLBase = "https://".concat(hostName).concat(this.noteStoreBaseQueryParam) ;
        
        this.userAgent = "Java";
    }
    
    /**
     * 
     * @param apiKey
     * @param apiAccount
     * @param apiSecret
     * @param hostName
     * @param userAgent 
     */
    public CFEvernote(String apiAccount, String apiKey, String hostName, String userAgent){
        
        this.apiAccount = apiAccount;
        this.apiKey = apiKey;
        this.hostName = hostName;
        this.userAgent = userAgent;
    }
    
    /************************************************
     *                methods                       *
     ***********************************************/
    
    public boolean Authenticate(String username, String password){
    
        // Set up the UserStore client. The Evernote UserStore allows you to
        // authenticate a user and access some information about their account.
        try{
            THttpClient userStoreTrans = new THttpClient(this.userStoreURL);
            userStoreTrans.setCustomHeader("User-Agent", userAgent);
            TBinaryProtocol userStoreProt = new TBinaryProtocol(userStoreTrans);
        
            userStore = new UserStore.Client(userStoreProt, userStoreProt);
        }
        catch(Exception ex){
            return false;
        }
    
        // Check that we can talk to the server
        try{
             boolean versionOk = userStore.checkVersion(this.userAgent,
                                                    com.evernote.edam.userstore.Constants.EDAM_VERSION_MAJOR,
                                                com.evernote.edam.userstore.Constants.EDAM_VERSION_MINOR);
    
            if (!versionOk) {
              System.err.println("Incomatible EDAM client protocol version");
              return false;
            }
        }
            catch(Exception ex){
            return false;   
        }
       

    // Authenticate using username & password
    AuthenticationResult authResult = null;
    
    try{
        authResult = userStore.authenticate(username, password, this.apiAccount, this.apiKey);
    } 
    catch (EDAMUserException ex) {
          // Note that the error handling here is far more detailed than you would 
          // provide to a real user. It is intended to give you an idea of why the 
          // sample application isn't able to authenticate to our servers.

          // Any time that you contact us about a problem with an Evernote API, 
          // please provide us with the exception parameter and errorcode. 
          String parameter = ex.getParameter();
          EDAMErrorCode errorCode = ex.getErrorCode();
          
          //check if its an oauth error, if so try to authenticate with o-auth
          if(errorCode.equals(com.evernote.edam.error.EDAMErrorCode.INVALID_AUTH)){
              
          }
          
          System.err.println("Authentication failed (parameter: " + parameter + " errorCode: " + errorCode + ")");


          return false;
        }
        catch(EDAMSystemException ex){
            return false;
        }
        catch(org.apache.thrift.TException ex){
            return false;
        }
    
        authToken = authResult.getAuthenticationToken();

        // The Evernote NoteStore allows you to accessa user's notes.    
        // In order to access the NoteStore for a given user, you need to know the 
        // logical "shard" that their notes are stored on. The shard ID is included 
        // in the URL used to access the NoteStore.
        User user = authResult.getUser();
        String shardId = user.getShardId();

        System.out.println("Successfully authenticated as " + user.getUsername());

        // Set up the NoteStore client 
        String noteStoreUrl = this.noteStoreURLBase + shardId;
        
        try{
            THttpClient noteStoreTrans = new THttpClient(noteStoreUrl);
            noteStoreTrans.setCustomHeader("User-Agent", userAgent);
            TBinaryProtocol noteStoreProt = new TBinaryProtocol(noteStoreTrans);
            noteStore = new NoteStore.Client(noteStoreProt, noteStoreProt);
        }
        catch(org.apache.thrift.transport.TTransportException ex){
            return false;
        }

        return true;
    }
    
    /************************************************
     *           mutators and accessors             *
     ***********************************************/
    
    /**
     * @return the apiKey
     */
    public String getApiKey() {
        return apiKey;
    }

    /**
     * @param apiKey the apiKey to set
     */
    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    /**
     * @return the apiAccount
     */
    public String getApiAccount() {
        return apiAccount;
    }

    /**
     * @param apiAccount the apiAccount to set
     */
    public void setApiAccount(String apiAccount) {
        this.apiAccount = apiAccount;
    }

    /**
     * @return the hostName
     */
    public String getHostName() {
        return hostName;
    }

    /**
     * @param hostName the hostName to set
     */
    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
    
    /**
     * 
     * @return returns the version number of this
     */
    public String getVersionNumber(){
        return MAJOR.concat(".").concat(MINOR);
    }
    
    public String getUserStoreURL(){
        return this.userStoreURL;
    }
    
    public String getNoteStoreURLBase(){
        return this.noteStoreURLBase;
    }
}
