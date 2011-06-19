/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sudios714.cfevernote;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author ranklam
 */
public class CFEvernoteTest {
    
    CFEvernote instance;
    
    public CFEvernoteTest() {
    }
    
    @Before
    public void setUp() {
         this.instance = new CFEvernote("123456","testaccount","sandbox.evernote.com");
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of getApiKey method, of class CFEvernote.
     */
    @Test
    public void testGetApiKey() {
    
        String expResult = "123456";
        
        String result = this.instance.getApiKey();
        
        assertEquals(expResult, result);
    }

    /**
     * Test of getApiAccount method, of class CFEvernote.
     */
    @Test
    public void testGetApiAccount() {
        String expResult = "testaccount";
        
        String result = instance.getApiAccount();
        
        assertEquals(expResult, result);
    }

    /**
     * Test of getHostName method, of class CFEvernote.
     */
    @Test
    public void testGetHostName() {
        String expResult = "sandbox.evernote.com";
        
        String result = instance.getHostName();
        assertEquals(expResult, result);
    }
}
