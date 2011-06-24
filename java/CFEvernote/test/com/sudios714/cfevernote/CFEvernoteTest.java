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
        this.instance = new CFEvernote("bittersweetryan.130C21A0AF2.687474703A2F2F6C6F63616C686F73742F746573742E63666D.C4470DF4C5AFE9A4948D0FA97B281F7C","sandbox.evernote.com","CFEvernote Test 1.0");
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
    public void testGetNoteList(){
        this.instance.listNotes();
    }
}
