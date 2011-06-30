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
    
    public CFEvernoteTest() {
    }
    
    @Before
    public void setUp() {

        try{
            this.instance = new CFEvernote("bittersweetryan.130E0A12D19.687474703A2F2F6C6F63616C686F73742F6366657665726E6F74652F63616C6C6261636B2E63666D.DA71E8C8608219D47C019820A88621FD","s1","56812","sandbox.evernote.com","CFEvernote Test 1.0");
        }
        catch(Exception ex){
            fail("Error on init");
        }
    }
    
    @After
    public void tearDown() {
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
    
    @Test
    public void testGetNoteStoreURLBase(){
        String expected = "https://sandbox.evernote.com/edam/note/";
        String actual = this.instance.getNoteStoreURLBase();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testGetUserAgent(){
        String expected = "CFEvernote Test 1.0";
        String actual = this.instance.getUserAgent();
        
        assertEquals(expected,actual);
    }
   
    @Test
    public void testGetNotebookListWithoutPassingInMaxNumber(){
        this.instance.listNotebooks();
    }
    
    @Test
    public void testGetShard(){
        String expected = "s1";
        String actual = this.instance.getShard();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testGetUserID(){
        String expected = "161";
        String actual = this.instance.getUserID();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testResettingAuthToken(){
        String expected = "1234556";
        
        this.instance.setAuthToken("1234556");
        
        String actual = this.instance.getAuthToken();
        
        assertEquals(expected,actual);
    }
}
