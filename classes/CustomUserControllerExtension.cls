/**
 * Created by new on 23.05.2017.
 */

public with sharing class CustomUserControllerExtension {

    private Custom_User__c user;
    public String errorMessage { get; set; }

    public CustomUserControllerExtension(ApexPages.StandardController stdController) {
        this.user = (Custom_User__c) stdController.getRecord();
    }

    public PageReference login() {
        PageReference returnPage;
        Custom_User__c loginUser;
        try {
            loginUser = CustomerUserService.getUserByEmail(user.Email__c);
        } catch (QueryException ex) {
            loginUser = null;
        }
        if (loginUser != null) {
            if (loginUser.Password__c == user.Password__c) {
                user = loginUser;
                returnPage = new PageReference('/apex/Main');
                returnPage.setRedirect(true);
                makeCookies();
                return returnPage;
            } else {
                errorMessage = 'Incorrect password, try again!';
            }
        } else {
            errorMessage = 'No such user, create new user!';
        }
        return null;
    }

    public PageReference register() {
        PageReference page = new PageReference('/apex/Register');
        page.setRedirect(true);
        return page;
    }

    public PageReference save() {
        upsert user;
        PageReference returnPage = new PageReference('/apex/Main');
        returnPage.setRedirect(true);
        makeCookies();
        return returnPage;
    }

    public PageReference logout() {
        Map<String, Cookie> cookies = ApexPages.currentPage().getCookies();
        List<Cookie> newCookies = new List<Cookie>();
        for (String key : cookies.keySet()) {
            newCookies.add(new Cookie(key, null, null, 0, false));
        }
        ApexPages.currentPage().setCookies(newCookies);
        PageReference page = new PageReference('/apex/Main');
        page.setRedirect(true);
        return page;
    }

    private void makeCookies() {
        List<Cookie> cookies = new List<Cookie>();
        Cookie idCookie = new Cookie('userId', user.Id, null, -1, false);
        cookies.add(idCookie);
        Cookie username = new Cookie('username', user.Name, null, -1, false);
        cookies.add(username);
        ApexPages.currentPage().setCookies(cookies);
    }


}