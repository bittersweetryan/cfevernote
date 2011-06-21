/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sudios714.cfevernote;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import java.io.*;

public class CFEvernoteTest {
    
    CFEvernote instance;
    
    String username;
    String password;
    String apiKey;
    String apiAccount;
    
    public CFEvernoteTest() {
    }
    
    @Before
    public void setUp() {
        this.getCredentialsFromFile("D:\\inetpub\\wwwroot\\cfevernote\\config.txt");
        this.instance = new CFEvernote(this.apiAccount,this.apiKey,"sandbox.evernote.com");
    }
    
    @After
    public void tearDown() {
    }
    
    @Test
    public void testGetApiAccount() {
        String expResult = "bittersweetryan";
        
        String result = instance.getApiAccount();
        
        assertEquals(expResult, result);
    }

    @Test
    public void testGetHostName() {
        String expResult = "sandbox.evernote.com";
        
        String result = instance.getHostName();
        assertEquals(expResult, result);
    }
    
    @Test
    public void testGetVersionNumber(){
        String expected = "0.1";
        String actual = this.instance.getVersionNumber();
        
        assertEquals(expected, actual);
    }
    
    @Test
    public void testGetUserStoreURL(){
        String expected = "https://sandbox.evernote.com/edam/user";
        String actual = this.instance.getUserStoreURL();
        
        assertEquals(expected,actual);
    }
    
    public void testGetNoteStoreURLBase(){
        String expected = "https://sandbox.evernote.com/edam/note/";
        String actual = this.instance.getNoteStoreURLBase();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testAuthenticateShouldReturnTrueForProperCredentials(){
        boolean expected = true;
        boolean actual = this.instance.Authenticate(username, password);
        
        assertEquals(expected, actual);
    }
    
    private void getCredentialsFromFile(String filename){
    
        BufferedReader input = null;

         try{
            input = new BufferedReader(new FileReader(filename));
        }
        catch(java.io.FileNotFoundException ex){
            fail("File not found");
        }
        
        //this seems like a lot of work for a test but since its OSS I want to hide my credentials
        try{
            String credentials = input.readLine();
            
            String[] credentialArray = credentials.split(",");
            
            if(credentialArray.length != 4){
                fail("Credential input failure.");
            }
            else{
                this.username = credentialArray[0];
                this.password = credentialArray[1];
                this.apiAccount = credentialArray[2];
                this.apiKey = credentialArray[3];
            }
        }
        catch(java.io.IOException ex){
            fail("IO exception");
        }
    }
}
