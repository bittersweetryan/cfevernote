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
import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

//imprt thrift
import java.util.Map;
import java.util.logging.FileHandler;

import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.transport.THttpClient;
import org.apache.thrift.transport.TTransportException;

public class CFEvernote {
   
    private static final short VERSION_MAJOR = 1;
    private static final short VERSION_MINOR = 18;
    
    private static final int DEFAULT_ROWS_RETURNED = 100;
    private static final int DEFAULT_MAX_ROWS = 9999;
    
    private String hostName;
    private String userStoreURL;
    private String noteStoreURLBase;
    private String noteStoreURL;
    private String userAgent;
    
    private String authToken;
    private String shard;
    private String userID;
    
    private String userStoreQueryParam = "/edam/user";
    private String noteStoreBaseQueryParam = "/edam/note/";
    
    private UserStore.Client userStore;
    private NoteStore.Client noteStore;
    
    private boolean initialized = false;
    /**
     * Default Constructer
     */
    public CFEvernote(){
        this.hostName = "";
    }
    
    public CFEvernote(String hostName, String userAgent){
        this.hostName = hostName;
        
        this.userStoreURL = "https://".concat(hostName).concat(this.userStoreQueryParam);
        this.noteStoreURLBase = "https://".concat(hostName).concat(this.noteStoreBaseQueryParam) ;
        
        this.userAgent = userAgent;
    }
    
    public CFEvernote(String authTolken, String shard, String userID, String hostName, String userAgent) throws Exception{
        this.hostName = hostName;
        this.userAgent = userAgent;
        this.authToken = authTolken;
        this.shard = shard;
        this.userID = userID;
        
        this.userStoreURL = "https://".concat(hostName).concat(this.userStoreQueryParam);
        this.noteStoreURLBase = "https://".concat(hostName).concat(this.noteStoreBaseQueryParam) ;
        
        this.userAgent = userAgent;
        
        this.initialized = this.initialize();
    }
    
    /**
     * public facing initialize method in case a user wants to create this object before oauth is done
     * @param authToken
     * @param shard
     * @param userID
     * @return
     * @throws Exception 
     */
    public boolean initialize(String authToken, String shard, String userID) throws Exception{
        this.shard = shard;
        this.userID = userID;
        this.authToken = authToken;
        
        this.setInitialized(this.initialize());
        
        return this.isInitialized();
    }
    
    /************************************************
     *                methods                       *
     ***********************************************/
    private boolean initialize() throws Exception {
        
        //setup the userstore
        THttpClient userStoreTrans = new THttpClient(this.userStoreURL);
        
        userStoreTrans.setCustomHeader("User-Agent", this.userAgent);
        
        TBinaryProtocol userStoreProt = new TBinaryProtocol(userStoreTrans);
        
        setUserStore(new UserStore.Client(userStoreProt, userStoreProt));

        // Check that we can talk to the server
        boolean versionOk = userStore.checkVersion(this.userAgent, VERSION_MAJOR, VERSION_MINOR);
        
        if (!versionOk) {
          return false;
        }

        // Set up the NoteStore client 
        String noteStoreUrl = this.noteStoreURLBase + this.getShard();
        
        THttpClient noteStoreTrans = new THttpClient(noteStoreUrl);
        noteStoreTrans.setCustomHeader("User-Agent", this.userAgent);
        
        TBinaryProtocol noteStoreProt = new TBinaryProtocol(noteStoreTrans);
        
        this.setNoteStore(new NoteStore.Client(noteStoreProt, noteStoreProt));

        return true;
    }
    
    /***
     * Will return the default number of notebooks if no number of notes is passed in
     */
    public ArrayList listNotebooks() throws Exception{
        return this.listNotebooks(DEFAULT_ROWS_RETURNED);
    }
    
    public ArrayList listNotebooks(int maxNotes) throws Exception{    

        this.checkInitialized();

            
        ArrayList<Notebook> notebooks;
        
        try{
            // First, get a list of all notebooks
            notebooks = (ArrayList)noteStore.listNotebooks(authToken);
            
            if(notebooks.size() > maxNotes){
                for(int i=maxNotes;i < notebooks.size(); i++){
                    notebooks.remove(i);
                }
            }
                
        }
        catch(Exception ex){
            throw ex;
        }
        
        return notebooks;
    }
    
    public Notebook getNotebook(String guid) throws Exception{
        
        this.checkInitialized();
        
        return noteStore.getNotebook(authToken, guid);
    }
    
    public Notebook getDefaultNotebook() throws Exception{
        this.checkInitialized();
        
        return this.noteStore.getDefaultNotebook(authToken);
    }
    
    public ArrayList listNotes() throws Exception{
        
        return this.listNotes(DEFAULT_ROWS_RETURNED);
    }
    
    public ArrayList listNotes(int maxNotes) throws Exception{
        return this.listNotes(maxNotes, null);
    }
    
    public Notebook createNotebook(String name) throws Exception{
        Notebook notebook = new Notebook();
        
        notebook.setName(name);
        
        notebook = this.noteStore.createNotebook(authToken, notebook);
        
        return notebook;
    }
    
    public ArrayList listNotes(int maxNotes, String notebookGUID)  throws Exception {    
        
        this.checkInitialized();
        
        // First, get a list of all notebooks
        ArrayList<Notebook> notebooks = this.listNotebooks(DEFAULT_MAX_ROWS);
        
        ArrayList<Note> notes = new ArrayList();
        
        for (Notebook notebook : notebooks) {
            notes.addAll(getNotesForNotebook(notebook, maxNotes));
            
            if(notes.size() >= maxNotes)
                break;
        }    
        
        //if we have more notes than the user asked for trim the list
        if(notes.size() > maxNotes){
            notes = (ArrayList)notes.subList(0, maxNotes - 1);
        }
        
        return notes;
    }
    
    
    public ArrayList getNotesForNotebook(String notebookGUID, int maxNotes) throws Exception{
        Notebook notebook = new Notebook();
        
        notebook.setGuid(notebookGUID);
        
        return this.getNotesForNotebook(notebook, maxNotes);
    }
    
    private ArrayList getNotesForNotebook(Notebook notebook, int maxNotes) throws Exception{
        
        ArrayList<Note> notes = new ArrayList();
        NoteFilter filter = new NoteFilter();

        filter.setNotebookGuid(notebook.getGuid());
        filter.setOrder(NoteSortOrder.CREATED.getValue());
        filter.setAscending(true);

        NoteList noteList = noteStore.findNotes(authToken, filter, 0, maxNotes);
          
        ArrayList<Note> notebookNotes = (ArrayList)noteList.getNotes();

        for (Note note : notebookNotes) {
            notes.add(note);
        }
           
        return notes;
    }
    
    /***
     * This is the only way I was able to create a note for now.  I'll try to pass in an object later
     * @param content
     * @param title
     * @param notebookGUID
     * @param created
     * @param tags
     * @return
     * @throws Exception 
     */
    public Note createNote(String content, String title, String notebookGUID, long created, String[] tags) throws Exception{
        
        this.checkInitialized();
        
        Note newNote = new Note();
        
        newNote.setContent(content);
        newNote.setTitle(title);
        newNote.setNotebookGuid(notebookGUID);
        newNote.setCreated(created);
        
        if(tags != null){
            for(String tag : tags){
                newNote.addToTagNames(tag);
            }
        }
        
        return createNote(newNote);
    }
    
    private Note createNote(Note note) throws Exception{
        Note createdNote;
        
        checkEmptyTitle(note);
        
        try{
            createdNote = noteStore.createNote(authToken, note);
        }
        catch(Exception ex){
            throw ex;
        }
    
        return createdNote;
    }
    
    private void checkEmptyTitle(Note note){
         if(!note.isSetTitle())
            note.setTitle("Created - ".concat(" ").concat(getFormattedDate()));
    }
    
    /**
    * Search a user's notes and display the results, I made a design decision to not abstract the details of a search
    * out of the coldfusion component.  This means that a formatted search string is expected
    */
    
    public ArrayList searchNotes(String formattedSearchString) throws Exception{
        return this.searchNotes(formattedSearchString,DEFAULT_ROWS_RETURNED);
    }
    
    /**
    * Search a user's notes and display the results, I made a design decision to not abstract the details of a search
    * out of the coldfusion component.  This means that a formatted search string is expected
    */
    public ArrayList searchNotes(String formattedSearchString, int maxRows) throws Exception{
    
        ArrayList<Note> noteList = new ArrayList();

        NoteFilter filter = new NoteFilter();
        filter.setWords(formattedSearchString);

        // Find the first 100 notes matching the search
        NoteList notes = noteStore.findNotes(authToken, filter, 0, maxRows);

        Iterator<Note> iter = notes.getNotesIterator();

        while (iter.hasNext()) {

            Note note = (Note)iter.next();
            // Note objects returned by findNotes() only contain note attributes
            // such as title, GUID, creation date, update date, etc. The note content 
            // and binary resource data are omitted, although resource metadata is included. 
            // To get the note content and/or binary resources, call getNote() using the note's GUID.

            Note fullNote = noteStore.getNote(authToken, note.getGuid(), true, true, false, false);

            noteList.add(fullNote);
        }
        
        return noteList;
    }
    
    private void checkInitialized() throws Exception{
         if(!this.isInitialized()){
            throw new Exception("Object not initalized");
        }
    }
    
    private String getFormattedDate(){
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        Date date = new Date();
        
        return dateFormat.format(date);
    }
    
    /************************************************
     *           mutators and accessors             *
     ***********************************************/
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
        return String.valueOf(VERSION_MAJOR).concat(".").concat(String.valueOf(VERSION_MINOR));
    }
    
    public String getUserStoreURL(){
        return this.userStoreURL;
    }
    
    public String getNoteStoreURLBase(){
        return this.noteStoreURLBase;
    }

    /**
     * @return the authToken
     */
    public String getAuthToken() {
        return authToken;
    }

    /**
     * @param authToken the authToken to set
     */
    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }

    /**
     * @return the userAgent
     */
    public String getUserAgent() {
        return userAgent;
    }

    /**
     * @param userAgent the userAgent to set
     */
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    /**
     * @return the shard
     */
    public String getShard() {
        return shard;
    }

    /**
     * @param shard the shard to set
     */
    public void setShard(String shard) {
        this.shard = shard;
    }

    /**
     * @return the userID
     */
    public String getUserID() {
        return userID;
    }

    /**
     * @param userID the userID to set
     */
    public void setUserID(String userID) {
        this.userID = userID;
    }

    /**
     * @return the initialized
     */
    public boolean isInitialized() {
        return initialized;
    }

    /**
     * @param initialized the initialized to set
     */
    public void setInitialized(boolean initialized) {
        this.initialized = initialized;
    }

    /**
     * @param noteStore the noteStore to set
     */
    public void setNoteStore(NoteStore.Client noteStore) {
        this.noteStore = noteStore;
    }

    /**
     * @param userStore the userStore to set
     */
    public void setUserStore(UserStore.Client userStore) {
        this.userStore = userStore;
    }
}
