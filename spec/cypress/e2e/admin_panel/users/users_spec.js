describe('Admin Panel Users', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openUserAP()
  })
  beforeEach(() => {
    cy.get('#tabs').within(() => {
      cy.get('#users').contains('Users').click()
    })
    cy.preserveAllCookiesOnce()
  })

  it('Validate program privileges', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')

    cy.get('a[href="#advanced"]').click()
    cy.get("#user_privilege_attributes_sheets_view_r").click()
    
    cy.get('a[href="#programs"]').click()
    cy.get("#addProgramPrivilegeBtn").click()

    cy.get('#project_privileges_list > fieldset > ol > li:nth-child(3)').within(() => {
      cy.get("input[type='checkbox']").click({ multiple: true })
    })

    const stub = cy.stub()  
    cy.on ('window:alert', stub)

    cy.get('#user_submit_action').contains('Create User').click().then(() => {
      expect(stub.getCall(0)).to.be.calledWith('Please select atlease one program in program privileges.')      
    })

    // cy.contains("Please select atleast one program in privilege")

    // cy.get('.flashes').contains('User was successfully created.')
    // cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 3)

    // cy.get('#tabs').within(() => {
    //   cy.get('#projects').contains('Programs').click()
    // })
    // cy.get('#index_table_projects > tbody > tr').first().within(() => {
    //   cy.get('.col-actions').contains('Edit').click()
    // })
    // cy.get('a[href="#advanced"]').click()
    // cy.get("span[data-select2-id='1']").click().type('user@test.com')
    // cy.get("li.select2-results__option--highlighted").click()
    // cy.get("#project_submit_action").click()
    // cy.get('#tabs').within(() => {
    //   cy.get('#users').contains('Users').click()
    // })
    // cy.get('#index_table_users > tbody > tr').first().within(() => {
    //   cy.get('.col-actions').contains('Edit').click()
    // })

  })

  it('Click on Users on tabs open users information page', function() {
    cy.get('#page_title').contains('Users').should('be.visible')
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('.pagination_information').contains('Displaying all 2 Users')
   // cy.get('#logout').click()
  })

  it('Open and close new User form', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
   // cy.get('#logout').click()
  })
  
  it('Could not create user if first name is blank', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.errors').contains("First name can't be blank")
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New User').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Could not create user if last name is blank', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.errors').contains("Last name can't be blank")
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New User').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Could not create user if email is blank', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.errors').contains("Email can't be blank")
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New User').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Could not create user if password is blank', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
    cy.get('#__password').clear()
    cy.get('#pass-word-generator-tab').contains('Password must contains 8 characters.')
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.errors').contains("Password can't be blank")
    cy.get('#page_title').contains('New User').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Position', function() {
    cy.get('.sortable').contains('Position').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Mr.').should('be.visible')
    cy.get('.sortable').contains('Position').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Manager').should('be.visible')
    cy.get('.sortable').contains('Position').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Mr.').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to First Name', function() {
    cy.get('.sortable').contains('First Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Test2').should('be.visible')
    cy.get('.sortable').contains('First Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Test1').should('be.visible')
    cy.get('.sortable').contains('First Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Test2').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Last Name', function() {
    cy.get('.sortable').contains('Last Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Client').should('be.visible')
    cy.get('.sortable').contains('Last Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Admin').should('be.visible')
    cy.get('.sortable').contains('Last Name').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Client').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Email', function() {
    cy.get('.sortable').contains('Email').click()
    cy.get('#index_table_users > tbody > tr').first().contains('client@test.com').should('be.visible')
    cy.get('.sortable').contains('Email').click()
    cy.get('#index_table_users > tbody > tr').first().contains('admin@test.com').should('be.visible')
    cy.get('.sortable').contains('Email').click()
    cy.get('#index_table_users > tbody > tr').first().contains('client@test.com').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Organization', function() {
    cy.get('.sortable').contains('Organization').click()
    cy.get('#index_table_users > tbody > tr').first().contains('Test Organization').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Phone Number', function() {
    cy.get('.sortable').contains('Phone Number').click()
    cy.get('#index_table_users > tbody > tr').first().contains('+447400123450').should('be.visible')
    cy.get('.sortable').contains('Phone Number').click()
    cy.get('#index_table_users > tbody > tr').first().contains('+447400123440').should('be.visible')
    cy.get('.sortable').contains('Phone Number').click()
    cy.get('#index_table_users > tbody > tr').first().contains('+447400123450').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Sort User according to Address', function() {
    cy.get('.sortable').contains('Address').click()
    cy.get('#index_table_users > tbody > tr').first().contains('56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK').should('be.visible')
    cy.get('.sortable').contains('Address').click()
    cy.get('#index_table_users > tbody > tr').first().contains('38 Wiltshire Rd, Leicester LE4 0JT, UK').should('be.visible')
    cy.get('.sortable').contains('Address').click()
    cy.get('#index_table_users > tbody > tr').first().contains('56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK').should('be.visible')
   // cy.get('#logout').click()
  })

  it('Search User contains email', function() {
    cy.get('#q_email').type('client@test.com').should('have.value', 'client@test.com')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Email contains client@test.com').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User by projects', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#q_project_ids').select('Test Project')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#q_project_ids').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
   // cy.get('#logout').click()
  })

  it('Search User contains Position', function() {
    cy.get('#q_title').type('Manager').should('have.value', 'Manager')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Position contains Manager').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User by organization', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#q_organization_id').select('Test Organization')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#q_organization_id').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
   // cy.get('#logout').click()
  })

  it('Search User contains First name', function() {
    cy.get('#q_first_name').type('Test1').should('have.value', 'Test1')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('First name contains Test1').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User contains Last name', function() {
    cy.get('#q_last_name').type('Admin').should('have.value', 'Admin')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Last name contains Admin').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User contains Phone number', function() {
    cy.get('#q_phone_number').type('+447400123450').should('have.value', '+447400123450')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Phone number contains +447400123450').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#q_phone_number').clear().type('+447400123440').should('have.value', '+447400123440')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Phone number contains +447400123440').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)

    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User contains Address', function() {
    cy.get('#q_address').type('56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK').should('have.value', '56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Address contains 56 Second Ave, Pensnett Trading Estate, Kingswinford DY6 7XN, UK').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)

    cy.get('#q_address').clear().type('38 Wiltshire Rd, Leicester LE4 0JT, UK').should('have.value', '38 Wiltshire Rd, Leicester LE4 0JT, UK')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Address contains 38 Wiltshire Rd, Leicester LE4 0JT, UK').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)

    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
   // cy.get('#logout').click()
  })

  it('Search User by state', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#q_status').select('inactive')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('.blank_slate').contains('No Users found').should('be.visible')
    cy.get('#q_status').select('active')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#q_status').select('Any')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
   // cy.get('#logout').click()
  })

  it('Could not Delete User of foreign constraint', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
   // cy.get('#logout').click()
  })

  it('Delete User', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
    cy.get('a[href="#advanced"]').click()
    cy.get("#user_privilege_attributes_sheets_view_r").click()
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('#index_table_users > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('User was successfully destroyed.').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
   // cy.get('#logout').click()
  })

  it('Create new user', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_first_name').type('New test').should('have.value', 'New test')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')

    cy.get('a[href="#advanced"]').click()
    cy.get("#user_privilege_attributes_sheets_view_r").click()
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.flashes').contains('User was successfully created.')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 3)
   // cy.get('#logout').click()
  })

})
