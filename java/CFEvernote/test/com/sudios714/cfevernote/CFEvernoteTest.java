/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sudios714.cfevernote;

import com.evernote.edam.notestore.*;
import com.evernote.edam.type.Note;
import com.evernote.edam.type.Notebook;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.hamcrest.CoreMatchers.*;
import org.junit.Ignore;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.util.ArrayList;
import org.powermock.modules.junit4.PowerMockRunner;

public class CFEvernoteTest {
    
    CFEvernote instance;
    
    
    private static final String AUTH_TOKEN = "S=s1:U=ddec:E=1317392a4ff:C=1316e6c48ff:P=7:A=bittersweetryan:H=67e9176d034e09126b3d8bfe84469b3e";
    private static final String SHARD = "s1";
    private static final String USER_ID = "56812";
    private static final String EVERNOTE_URL = "sandbox.evernote.com";
    private static final String USER_AGENT = "CFEvernote Test";
    private static final String VERSION = "1.18";
    private static final String DEFAULT_NOTEBOOK_GUID = "aac89a28-c080-4bde-92f6-9eaa8c27ee49";
    
    public CFEvernoteTest() {
    }
    
    @Before
    public void setUp() {

        try{
            this.instance = new CFEvernote(AUTH_TOKEN,SHARD,USER_ID,EVERNOTE_URL,USER_AGENT);
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
        String expected = VERSION;
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
        String expected = USER_AGENT;
        String actual = this.instance.getUserAgent();
        
        assertEquals(expected,actual);
    }
   
    @Test
    public void testGetNotebookListWithoutPassingInMaxNumber(){
        
        try{
            ArrayList notebooks = (ArrayList)this.instance.listNotebooks();
            //this test is a little fragile since it depends on the number of notebooks in the account, should make better
            int expected = 9;
            int actual = notebooks.size();

            assertEquals(expected,actual);
        }
        catch(Exception ex){
            fail("Exception thrown by listNotebooks()");
        }
    }
    
    @Test
    public void testGetShard(){
        String expected = SHARD;
        String actual = this.instance.getShard();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testGetUserID(){
        String expected = USER_ID;
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
    
    @Test (expected=Exception.class)
    public void testCallingGetNotesbooksWithoutInitilzingThrowsError() throws Exception{
        CFEvernote cfe = new CFEvernote();
        
            cfe.listNotebooks();
   
    }
    
    @Test
    public void testGetNotesWithNoMaxReturnsNotes() throws Exception{
        ArrayList notes = this.instance.listNotes();
        
        assertTrue(notes.size() > 0);
    } 
    
    @Test
    public void testGetNotesWitMaxReturnsMaxNumberOfNotes() throws Exception{
        int expected = 2;
        
        ArrayList notes = this.instance.listNotes(2);
        int actual = notes.size();
        
        assertEquals(expected,actual);
    }
    
    @Test
    public void testGetDefaultNotebookShouldReturnNotebook() throws Exception{
        Class expected = Notebook.class;
        
        Notebook notebook = this.instance.getDefaultNotebook();
        System.out.print("GUID" + notebook.getGuid());
        
        Class actual = notebook.getClass();
        
        assertEquals(expected,actual);
        
        assertTrue(notebook.isDefaultNotebook());
    }
    
    @Test
    public void testGetNotebookShouldReturnNotebook() throws Exception{
        String expected = "aac89a28-c080-4bde-92f6-9eaa8c27ee49";
        
        Notebook notebook = this.instance.getNotebook(DEFAULT_NOTEBOOK_GUID);
        
        String actual = notebook.getGuid();
        
        assertEquals(expected,actual);
    }
     /* commenting out for now becuase i'm having problems getting coldfusion to pass in the correct object
    @Test
    public void testCreateNoteByPassingInNoteObject() throws Exception{
        
        Note mockNote = mock(Note.class);
        NoteStore.Client mockClient = mock(NoteStore.Client.class);
        
        instance.setNoteStore(mockClient);
        
        when(mockClient.createNote(AUTH_TOKEN, mockNote)).thenReturn(mockNote);
                
        Note createdNote = instance.createNote(mockNote);
        //make sure the note was returned
        assertEquals(mockNote,createdNote);
        
        //make sure that cfevernote got called
        verify(mockClient).createNote(AUTH_TOKEN, mockNote);
    }
    */
    @Test
    public void testCreatingANote() throws Exception{
         Note mockNote = mock(Note.class);
         NoteStore.Client mockClient = mock(NoteStore.Client.class);
        
        instance.setNoteStore(mockClient);
        
        when(mockNote.getContent()).thenReturn("Hello Note");
        
        String[] tags = new String[2];
        
        tags[0] = "tag";
        tags[1] = "notherTag";
        
        Note createdNote = instance.createNote("Hello Note","Hello Title",
                                               null,3423423l,
                                               null);
        
        //becuase I can't mock the note object thats being created in the cfevernote class I can't
        //do much more with this method until I can learn to verivy and mock based on a class instead of an actual
        //object
    }
    
    @Test
    public void testCreatingANotebook() throws Exception{
        Notebook mockNotebook = mock(Notebook.class);
        
        NoteStore.Client mockClient = mock(NoteStore.Client.class);
        
        instance.setNoteStore(mockClient);
        
        when(mockNotebook.getName()).thenReturn("Test Notebook");
        
        Notebook createdNotebook = instance.createNotebook("Test Notebook");
    }
    
    @Test
    public void testListNotesForNotebookReturnsNotesForThatNotebook() throws Exception{
        
        ArrayList noteList = this.instance.getNotesForNotebook(DEFAULT_NOTEBOOK_GUID, 100);
        
        assertTrue(noteList.size() > 0);
     
    }
    
}
