/**
 * Created by new on 26.05.2017.
 */

public with sharing class HeaderController {

    //Properties
    public String welcome { get; private set; }
    public Boolean logged {get; private set;}

    //Controller constructor
    public HeaderController() {
        Cookie username = ApexPages.currentPage().getCookies().get('username');
        if (username != null) {
            logged = true;
            welcome = 'Welcome, ' + username.getValue();
        }
    }

    //Methods
    public PageReference goToLogin() {
        PageReference page = new PageReference('/apex/LoginPage');
        page.setRedirect(true);
        return page;
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
        logged = false;
        return page;
    }

}