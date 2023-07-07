describe('Sheets Tasks View', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('effort/basic')
    // cy.appScenario('provide_all_privileges')

  })
  beforeEach(() => {
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    cy.get('[data-cy=effort]').contains('Effort').should('be.visible').click()
  })
  
  after(() => {
    // cy.clearCookies()
  })
  it('Open Sheets efforts in a facility', function() {
    cy.contains('Search Tasks').should('be.visible')
    cy.contains('Week Of Begin:').should('be.visible')
    cy.contains('Week Of End:').should('be.visible')
    cy.contains('Summary').should('be.visible')
  })

  it('Add user effort sheet', function() {
    cy.get('[data-cy=add_user_select]').type('Test1 Admin')
    cy.get("[data-cy=add_user_option]").contains("Test1 Admin").click()
    cy.get('[data-cy=effort_tab_pane]').its('length').should('be.eq', 1)
    cy.get('[data-cy=add_user_btn]').click()
    cy.get('[data-cy=effort_tab_pane]').its('length').should('be.eq', 2)   
  })

  it('Add effort to effort sheet', function() {
    cy.get('[data-cy=add_user_select]').type('Test1 Admin')
    cy.get("[data-cy=add_user_option]").contains("Test1 Admin").click()
    cy.get('[data-cy=effort_tab_pane]').its('length').should('be.eq', 2)
    cy.get('[data-cy=add_user_btn]').click()
    cy.get('[data-cy=effort_tab_pane]').its('length').should('be.eq', 3)

    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('#tab-2').click()

      cy.get('[data-cy=effort_tab_pane]').eq(2).within(() => {

        cy.get("[data-cy=add_edit_effort_btn]").click()
        cy.get("[data-cy=effort_input]").eq(0).clear().type("10")
        cy.get("[data-cy=effort_input]").eq(2).clear().type("20")
        cy.get("[data-cy=save_effort_btn]").click()
        // checking actual value
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(1).contains("30").should('be.visible')
        // checking task name
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(2).contains("Test Task 1").should('be.visible')
        //checking effort value in column
        cy.get("[data-cy=effort_table] div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(3).contains("10").should('be.visible')

      })
    })    
  })

  it('update effort to effort sheet', function() {
    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('#tab-1').click()
      cy.get('[data-cy=effort_tab_pane]').eq(1).within(() => {

        cy.get("[data-cy=add_edit_effort_btn]").click()
        cy.get("[data-cy=effort_input]").eq(0).clear().type("20")
        cy.get("[data-cy=effort_input]").eq(2).clear().type("20")
        cy.get("[data-cy=save_effort_btn]").click()
        // checking actual value
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(1).contains("40").should('be.visible')
        // checking task name
        cy.get("[data-cy=effort_table] > div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(2).contains("Test Task 1").should('be.visible')
        //checking effort value in column
        cy.get("[data-cy=effort_table] div.el-table__body-wrapper.is-scrolling-left > table > tbody > tr > td").eq(3).contains("20").should('be.visible')

      })   
    })
  })

  it('Search task by typing task name', function() {
    cy.get('[data-cy=search_tasks]').clear().type('task is not in the list').should('have.value', 'task is not in the list')
    cy.contains('You currently have no Tasks or *Excluded Tasks in this Project. Please add a task or adjust the Week of End filter.').should('be.visible')

    cy.get('[data-cy=search_tasks]').clear().type('Task 1').should('have.value', 'Task 1')

    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('[data-cy=effort_tab_pane]').eq(0).within(() => {
        cy.get('[data-cy=effort_table]').eq(0).within(() => {
          cy.get(".el-table__body > tbody > tr").its('length').should('be.eq', 1)
        })
      })
    })
  })

  it('Select by week of begin', function() {
    cy.get("[data-cy=week_begin_select]").click()
    cy.get("[data-cy=week_begin_options]").eq(2).click()
    cy.get("[data-cy=week_begin_options]").eq(2)
    cy.get('[data-cy=effort_tab]').within(() => {
      cy.get('[data-cy=effort_tab_pane]').eq(0).within(() => {
        cy.get('[data-cy=effort_table]').eq(0).within(() => {
          cy.get(".week_date_column").eq(0).contains('20 Jan 23').should('be.visible')
        })
      })
    })
  })

  it.skip('Select by week of end', function() {
    cy.get("[data-cy=week_end_select]").click()
    cy.get("[data-cy=week_end_options]").eq(5).click()
    cy.get('[data-cy=effort_tab]').within(() => {

      cy.get('[data-cy=effort_tab_pane]').eq(0).within(() => {
      
        cy.get('[data-cy=effort_table]').eq(0).within(() => {
          cy.get(".week_date_column").last().invoke('html').then((val) => console.log("week end",JSON.stringify(val)))
          cy.get(".week_date_column").last().contains('18 Aug 23').should('be.visible')
        })
      })
    })
  })
})
