describe('Admin Panel Users', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openUserAP()
  })

  it('Click on Users on tabs open users information page', function() {
    cy.get('#page_title').contains('Users').should('be.visible')
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new User form', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  // it('Create new user', function() {
  //   cy.get('.action_item > a').contains('New User').click()
  //   cy.get('#page_title').contains('New User').should('be.visible')
  //   cy.get('#user_first_name').type('New test').should('have.value', 'New test')
  //   cy.get('#user_last_name').type('user').should('have.value', 'user')
  //   cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
  //   cy.get('#user_submit_action').contains('Create User').click()
  //   cy.get('.flashes').contains('User was successfully created.')
  //   cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 3)
  //   cy.get('#logout').click()
  // })

  it('Could not create user if first name is blank', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#user_last_name').type('user').should('have.value', 'user')
    cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
    cy.get('#user_submit_action').contains('Create User').click()
    cy.get('.errors').contains("First name can't be blank")
    cy.get('.inline-errors').contains("can't be blank")
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('#logout').click()
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
    cy.get('#logout').click()
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
    cy.get('#logout').click()
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
    cy.get('#logout').click()
  })

  it('Could not Delete User of foreign constraint', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  // it('Delete User', function() {
  //   cy.get('.action_item > a').contains('New User').click()
  //   cy.get('#user_first_name').type('New test').should('have.value', 'New test')
  //   cy.get('#user_last_name').type('user').should('have.value', 'user')
  //   cy.get('#user_email').type('user@test.com').should('have.value', 'user@test.com')
  //   cy.get('#user_submit_action').contains('Create User').click()
  //   cy.get('#index_table_users > tbody > tr').first().within(() => {
  //     cy.get('.col-actions').contains('Delete').click()
  //   })
  //   cy.get('.flashes').contains('User was successfully destroyed.').should('be.visible')
  //   cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
  //   cy.get('#logout').click()
  // })

  it('Search User contains name', function() {
    cy.get('#q_email').type('client@test.com').should('have.value', 'client@test.com')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Email contains client@test.com').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    cy.get('#logout').click()
  })
})
