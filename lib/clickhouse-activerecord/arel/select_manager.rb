module ClickhouseActiverecord::Arel

    class SelectManager < ::Arel::SelectManager

      def initialize(table = nil)
        @ast   =  SelectStatement.new
        @ctx    = @ast.cores.last
        from table
        @columns_grouped = []
      end

      def limit_by by, limit, offset
        @ast.limit_by = Nodes::LimitBy.new(::Arel.sql(by), limit, offset)
        self
      end

      def using(*exprs)
        @ctx.source.right.last.right = ::ClickhouseActiverecord::Arel::Nodes::Using.new(::Arel.sql(exprs.join(',')))
        self
      end

      def group(*columns)
        columns.each do |column|

          unless @columns_grouped.include? column
            @columns_grouped.push column

            column = ::Arel::Nodes::SqlLiteral.new(column) if String === column
            column = ::Arel::Nodes::SqlLiteral.new(column.to_s) if Symbol === column

            @ctx.groups.push ::Arel::Nodes::Group.new column

          end

        end
        self
      end

      ::Arel::Nodes::SqlLiteral.class_eval do
        include ::ClickhouseActiverecord::Arel::Extensions::Functions
      end

      ::Arel::Nodes::InfixOperation.class_eval do
        include ::ClickhouseActiverecord::Arel::Extensions::Functions
      end

      ::Arel::Attributes::Attribute.class_eval do
        include ::ClickhouseActiverecord::Arel::Extensions::Functions
      end

      ::Arel::Nodes::Node.class_eval do
        include ::ClickhouseActiverecord::Arel::Extensions::NodeExpressions
      end

    end

end